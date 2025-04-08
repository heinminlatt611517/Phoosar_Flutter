import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

const appId = "98f3b99e6035492fbf02c10e7e2a1b90";
const token = "007eJxTYChyN9/HGt/9x+hl377Zqc371+24VGCWkuO6/nyY4GGrTHkFBkuLNOMkS8tUMwNjUxNLo7SkNAOjZEODVPNUo0TDJEuD6Rc+pzcEMjKU1s1lZWSAQBBfgKEgIz+/OLEoLDMlNT8oPz+XgQEAEawlEg==";
const channel = "phoosarVideoRoom";

class VideoCallPage extends StatefulWidget {
  final String roomId;

  const VideoCallPage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool muted = false;

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  /// Initialize Agora SDK
  Future<void> _initializeAgora() async {
    var status = await [Permission.microphone, Permission.camera].request();
    if (status[Permission.microphone]?.isGranted == false || status[Permission.camera]?.isGranted == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone or Camera permission not granted')),
      );
      return;
    }

    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          setState(() {
            _localUserJoined = false;
            _remoteUid = null;
          });
        },
      ),
    );

    /// Set client role and enable video
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    /// Join the channel
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
        actions: [
          IconButton(
            icon: Icon(muted ? Icons.mic_off : Icons.mic),
            onPressed: _toggleMute,
          ),
          IconButton(
            icon: const Icon(Icons.call_end),
            onPressed: _endCall,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
                    : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.roomId),
        ),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: const CircularProgressIndicator(color: primaryColor)),
          10.vGap,
          const Text(
            'Calling...',
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }

  /// Toggle mute
  Future<void> _toggleMute() async {
    setState(() {
      muted = !muted;
    });
    await _engine.muteLocalAudioStream(muted);
  }

  /// End the call
  void _endCall() {
    Navigator.pop(context);
    _dispose(); // Clean up resources
  }
}
