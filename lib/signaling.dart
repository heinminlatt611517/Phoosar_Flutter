import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:supabase/supabase.dart';

typedef void StreamStateCallback(MediaStream stream);

class Signaling {
  final SupabaseClient supabase;
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;

  Signaling(this.supabase);

  Future<String> createRoom(RTCVideoRenderer remoteRenderer) async {
    final roomResponse = await supabase
        .from('rooms')
        .insert({})
        .select()
        .single();

    roomId = roomResponse['id'].toString();
    print('Create PeerConnection with configuration: $configuration');

    peerConnection = await createPeerConnection(configuration);
    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // Collect ICE candidates
    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) async {
      print('Got candidate: ${candidate.toMap()}');
      await supabase.from('caller_candidates').insert({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'room_id': roomId
      });
    };

    // Create offer
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    print('Created offer: $offer');

    // Update room with offer
    await supabase.from('rooms').update({
      'offer': {
        'sdp': offer.sdp,
        'type': offer.type,
      },
    }).eq('id', roomId!);

    currentRoomText = 'Current room is $roomId - You are the caller!';
    print('New room created with SDK offer. Room ID: $roomId');

    // Setup remote track handler
    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');
      event.streams[0].getTracks().forEach((track) {
        print('Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
    };

    supabase.from('rooms').stream(primaryKey: ['id']).eq('id', roomId!).listen((event) async {
      for (var record in event) {
        final data = record;
        if (peerConnection?.getRemoteDescription() != null && data['answer'] != null) {
          var answer = RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );
          print("Got answer from remote peer");
          await peerConnection?.setRemoteDescription(answer);
        }
      }
    });


    supabase.from('callee_candidates').stream(primaryKey: ['id']).eq('room_id', roomId!).listen((event) {
      for (var record in event) {
        var data = record;
        print('Got new remote ICE candidate: ${jsonEncode(data)}');
        peerConnection!.addCandidate(
          RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex'],
          ),
        );
      }
    });

    return roomId!;
  }

  Future<void> joinRoom(String roomId, RTCVideoRenderer remoteVideo) async {
    this.roomId = roomId;

    // Get room data
    final roomResponse = await supabase
        .from('rooms')
        .select()
        .eq('id', roomId)
        .single();

    print('Create PeerConnection with configuration: $configuration');
    peerConnection = await createPeerConnection(configuration);
    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // Collect ICE candidates
    peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) async {
      if (candidate == null) {
        print('onIceCandidate: complete!');
        return;
      }
      print('onIceCandidate: ${candidate.toMap()}');
      await supabase.from('callee_candidates').insert({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'room_id': roomId
      });
    };

    // Setup remote track handler
    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');
      event.streams[0].getTracks().forEach((track) {
        print('Add a track to the remoteStream: $track');
        remoteStream?.addTrack(track);
      });
    };

    // Set remote description from offer
    var offer = roomResponse['offer'];
    await peerConnection?.setRemoteDescription(
      RTCSessionDescription(offer['sdp'], offer['type']),
    );

    // Create answer
    var answer = await peerConnection!.createAnswer();
    print('Created Answer $answer');
    await peerConnection!.setLocalDescription(answer);

    // Update room with answer
    await supabase.from('rooms').update({
      'answer': {
        'sdp': answer.sdp,
        'type': answer.type,
      }
    }).eq('id', roomId);

    supabase.from('caller_candidates').stream(primaryKey: ['id']).eq('room_id', roomId).listen((event) {
      for (var record in event) {
        var data = record;
        print('Got new remote ICE candidate: $data');
        peerConnection!.addCandidate(
          RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex'],
          ),
        );
      }
    });
  }

  Future<void> openUserMedia(RTCVideoRenderer localVideo, RTCVideoRenderer remoteVideo) async {
    var stream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': false
    });

    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  Future<void> hangUp(RTCVideoRenderer localVideo) async {
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    if (roomId != null) {
      // Clean up all data in Supabase
      await supabase.from('callee_candidates').delete().eq('room_id', roomId!);
      await supabase.from('caller_candidates').delete().eq('room_id', roomId!);
      await supabase.from('rooms').delete().eq('id', roomId!);
    }

    localStream?.dispose();
    remoteStream?.dispose();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }
}
