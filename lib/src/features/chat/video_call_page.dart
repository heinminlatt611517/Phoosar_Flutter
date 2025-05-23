// import 'dart:async';
// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:phoosar/src/utils/fonts.dart';
// import 'package:phoosar/src/utils/gap.dart';
// import 'package:agora_rtm/agora_rtm.dart';
//
//
// const String appId = "5cb8d4c222274b1d8ef5812c33239407";
// const String token = "007eJxTYLCJWzWlXWh32LfZva6/tvWY/OKWmMD0ciebR+0beVP9mbkKDKbJSRYpJslGQGBukmSYYpGaZmphaJRsbGxkbGliYL7t+vf0hkBGhmeazqyMDBAI4qswmKemGKZYGqfpmhibmeiaWBol64I06xompyYmmhkbmaWkJjMwAACNeCc/";
//
// class VideoCallPage extends StatefulWidget {
//   final String roomId;
//   final String otherUserName;
//   final String otherProfileImage;
//
//   const VideoCallPage({super.key, required this.roomId,required this.otherUserName,required this.otherProfileImage});
//
//   @override
//   State<VideoCallPage> createState() => _VideoCallPageState();
// }
//
// class _VideoCallPageState extends State<VideoCallPage> {
//   late final RtcEngine _engine;
//   bool _localUserJoined = false;
//   int? _remoteUid;
//   bool _muted = false;
//   bool _callEnded = false;
//   late RtmClient _rtmClient;
//   final String _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
//
//   @override
//   void initState() {
//     super.initState();
//     _initRTM();
//     _initAgora();
//   }
//
//   @override
//   void dispose() {
//     _leaveChannel();
//     _rtmClient.unsubscribe(widget.roomId);
//     _rtmClient.logout();
//     super.dispose();
//   }
//
//
//   ///init RTM for signaling
//   Future<void> _initRTM() async {
//     final (status, client) = await RTM(appId, _userId);
//
//     if (status.error) {
//       debugPrint('RTM init failed: ${status.reason}');
//       return;
//     }
//
//     _rtmClient = client;
//     debugPrint('RTM initialized');
//
//     _rtmClient.addListener(
//         message: (event) {
//           final message = utf8.decode(event.message!);
//           debugPrint('RTM Message: $message');
//
//           if (message == 'end_call') {
//             setState(() => _callEnded = true);
//             Future.delayed(Duration(seconds: 2), () {
//               if (mounted) _onCallEnd();
//             });
//           }
//         },
//         linkState: (event) {
//           debugPrint('RTM link changed: ${event.currentState}');
//         }
//     );
//
//     final (loginStatus, _) = await _rtmClient.login(appId);
//     if (loginStatus.error) {
//       debugPrint('RTM login failed: ${loginStatus.reason}');
//       return;
//     }
//
//     final (subStatus, _) = await _rtmClient.subscribe(widget.roomId);
//     if (subStatus.error) {
//       debugPrint('RTM channel subscribe failed: ${subStatus.reason}');
//     } else {
//       debugPrint('RTM subscribed to channel');
//     }
//   }
//
//
//   ///init agora
//   Future<void> _initAgora() async {
//     await [Permission.microphone, Permission.camera].request();
//
//     _engine = createAgoraRtcEngine();
//
//     await _engine.initialize(
//       RtcEngineContext(appId: appId, channelProfile: ChannelProfileType.channelProfileCommunication),
//     );
//
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (connection, elapsed) {
//           debugPrint("Local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (connection, remoteUid, elapsed) {
//           debugPrint("Remote user $remoteUid joined");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (connection, remoteUid, reason) {
//           debugPrint("Remote user $remoteUid left");
//           setState(() {
//             _callEnded = true;
//             _remoteUid = null;
//           });
//           Future.delayed(Duration(seconds: 2), () {
//             if (mounted) _onCallEnd();
//           });
//         },
//         onError: (err, msg) {
//           debugPrint("[❌ onError] $err - $msg");
//         },
//       ),
//     );
//
//     await _engine.enableVideo();
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.startPreview();
//
//     ///get dynamic token
//     String token = await _getToken(widget.roomId, '0');
//
//     await _engine.joinChannel(
//       token: token,
//       channelId: widget.roomId,
//       uid: 0,
//       options: const ChannelMediaOptions(
//         publishCameraTrack: true,
//         publishMicrophoneTrack: true,
//         autoSubscribeAudio: true,
//         autoSubscribeVideo: true,
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       ),
//     );
//   }
//
//   ///get dynamic token from server
//   Future<String> _getToken(String channelName, String uid) async {
//     final response = await http.get(
//       Uri.parse('https://phoosar-7674809880b9.herokuapp.com/rtc/${widget.roomId}/publisher/userAccount/0/'),
//     );
//
//     if (response.statusCode == 200) {
//       debugPrint("RtcToken>>>>>${jsonDecode(response.body)['rtcToken']}");
//       return jsonDecode(response.body)['rtcToken'];
//     } else {
//       throw Exception('Failed to generate token');
//     }
//   }
//
//   ///leave channel
//   Future<void> _leaveChannel() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }
//
//   ///call end
//   void _onCallEnd() async {
//     try {
//       await _rtmClient.publish(widget.roomId, 'end_call', channelType: RtmChannelType.message, customType: 'PlainText');
//     } catch (e) {
//       debugPrint('Failed to send end call signal: $e');
//     }
//     Navigator.pop(context);
//   }
//
//   ///mute
//   void _onToggleMute() {
//     setState(() {
//       _muted = !_muted;
//     });
//     _engine.muteLocalAudioStream(_muted);
//   }
//
//   ///switch camera
//   void _onSwitchCamera() {
//     _engine.switchCamera();
//   }
//
//   ///custom toolbar
//   Widget _toolbar() {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Visibility(
//         visible: _callEnded == false,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               _actionButton(
//                 icon: _muted ? Icons.mic_off : Icons.mic,
//                 color: _muted ? Colors.white : Colors.blueAccent,
//                 bgColor: _muted ? Colors.blueAccent : Colors.white,
//                 onPressed: _onToggleMute,
//               ),
//               _actionButton(
//                 icon: Icons.call_end,
//                 color: Colors.white,
//                 bgColor: Colors.redAccent,
//                 onPressed: _onCallEnd,
//                 size: 35,
//                 padding: 15,
//               ),
//               _actionButton(
//                 icon: Icons.switch_camera,
//                 color: Colors.blueAccent,
//                 bgColor: Colors.white,
//                 onPressed: _onSwitchCamera,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _actionButton({
//     required IconData icon,
//     required Color color,
//     required Color bgColor,
//     required VoidCallback onPressed,
//     double size = 20.0,
//     double padding = 12.0,
//   }) {
//     return RawMaterialButton(
//       onPressed: onPressed,
//       shape: const CircleBorder(),
//       elevation: 2.0,
//       fillColor: bgColor,
//       padding: EdgeInsets.all(padding),
//       child: Icon(icon, color: color, size: size),
//     );
//   }
//
//   ///remote user preview
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: widget.roomId),
//         ),
//       );
//     } else {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(100),
//               child: CachedNetworkImage(
//                 imageUrl: widget.otherProfileImage,
//                 height: 100,
//                 width: 100,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             3.vGap,
//             Text(
//               widget.otherUserName,
//               style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: kFontArticulatCFBold),
//             ),
//             3.vGap,
//             Text(
//               _callEnded ? 'Call Ended' : 'Calling...',
//               style: TextStyle(color: Colors.white),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   ///local user preview
//   Widget _localPreview() {
//     if (_localUserJoined) {
//       return Visibility(
//         visible: _callEnded == false,
//         child: AgoraVideoView(
//           controller: VideoViewController(
//             rtcEngine: _engine,
//             canvas: const VideoCanvas(uid: 0),
//           ),
//         ),
//       );
//     } else {
//       return const Center(child: CircularProgressIndicator());
//     }
//   }
//
//   ///content view
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(
//           children: [
//             Center(child: _remoteVideo()),
//             Positioned(
//               top: 20,
//               left: 20,
//               width: 100,
//               height: 150,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: _localPreview(),
//               ),
//             ),
//             _toolbar(),
//           ],
//         ),
//       ),
//     );
//   }
// }
