import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/features/chat/chat_page.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:video_player/video_player.dart';

class MatchScreen extends ConsumerStatefulWidget {
  const MatchScreen({super.key, required this.matchProfileData});
  final ProfileData? matchProfileData;

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  bool showUI = false;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    _videoController = VideoPlayerController.asset('assets/images/728.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController!.play();
      });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          showUI = true;
        });
        showSnackBarFun(context);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selfProfileData = ref.watch(selfProfileProvider);
    return Scaffold(
      backgroundColor: whitePaleColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            _videoController != null && _videoController!.value.isInitialized
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: VideoPlayer(_videoController!),
                  )
                : Container(),
            Visibility(
              visible: showUI,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  20.vGap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width * 0.28,
                          height: MediaQuery.of(context).size.width * 0.28,
                          fit: BoxFit.cover,
                          imageUrl:
                              (selfProfileData?.data?.profileImages != null &&
                                      selfProfileData!
                                          .data!.profileImages!.isNotEmpty)
                                  ? selfProfileData.data?.profileImages![0] ??
                                      errorImageUrl
                                  : errorImageUrl,
                        ),
                      ),
                      14.hGap,
                      ClipOval(
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width * 0.28,
                          height: MediaQuery.of(context).size.width * 0.28,
                          fit: BoxFit.cover,
                          imageUrl:
                              (widget.matchProfileData?.profileImages != null &&
                                      widget.matchProfileData!.profileImages!
                                          .isNotEmpty)
                                  ? widget.matchProfileData!.profileImages![0]
                                  : errorImageUrl,
                        ),
                      ),
                    ],
                  ),
                  30.vGap,
                  Center(
                    child: Text(
                      'Let the show begin!',
                      style: GoogleFonts.roboto(
                        fontSize: largeFontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  24.vGap,
                  Center(
                    child: InkWell(
                      onTap: () async {
                        try {
                          // Accessing RoomProvider to create a room
                          final roomId = await ref
                              .read(roomsProvider.notifier)
                              .createRoom(widget
                                  .matchProfileData!.supabaseUserId
                                  .toString());
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                      roomId: roomId,
                                      otherProfileImage: widget.matchProfileData
                                              ?.profileImages?.first ??
                                          "",
                                      otherUserName: widget
                                          .matchProfileData!.name
                                          .toString())));
                        } catch (e) {
                          log("Failed to create a new room: ${e.toString()}");
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'MESSAGE',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: smallFontSize,
                            color: whiteColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  20.vGap,
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Text(
                          'CONTINUE',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: smallFontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showSnackBarFun(context) {
    SnackBar snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.heart_broken,
            size: 15,
            color: Colors.red,
          ),
          4.hGap,
          Text(
            'You received 5 💕 for getting a match',
            style: GoogleFonts.roboto(
              fontSize: smallFontSize,
              color: whiteColor,
            ),
          ),
        ],
      ),
      backgroundColor: blackColor,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 40, left: 1, right: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
