import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/features/chat/chat_page.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:video_player/video_player.dart';
import '../../common/widgets/icon_button.dart';

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
    super.initState();

    _videoController = VideoPlayerController.asset('assets/images/match_bg.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController!.play();

        final duration = _videoController!.value.duration;
        final targetPosition = duration - Duration(seconds: 5);

        _videoController!.addListener(() {
          if (_videoController!.value.position >= targetPosition) {
            if (!showUI) {
              setState(() {
                showUI = true;
              });
              showSnackBarFun(context);
            }
          }
        });
      });
  }
  @override
  Widget build(BuildContext context) {
    var selfProfileData = ref.watch(selfProfileProvider);
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whitePaleColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: screenHeight,
        child: Stack(
          children: [
            _videoController != null && _videoController!.value.isInitialized
                ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: screenHeight,
              child: VideoPlayer(_videoController!),
            )
                : Container(),
            Visibility(
              visible: showUI,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
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
                      SizedBox(width: screenHeight * 0.02), // 2% of screen height
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
                  SizedBox(height: screenHeight * 0.08),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Image.asset(
                        'assets/images/what_a_match.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.07),
                  ///chat now button
                  Center(
                    child: InkWell(
                      onTap: () async {
                        try {
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
                          ref.invalidate(findListNotifierProvider);
                        } catch (e) {
                          log("Failed to create a new room: ${e.toString()}");
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: kMarginXXLarge),
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Text(
                          'CHAT NOW',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.archivoBlack(
                            fontSize: kTextRegular3x,
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08),
                  ///cancel button
                  CommonIconButton(
                    onTap: () async {
                      ref.invalidate(findListNotifierProvider);
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.transparent,
                    icon: Image.asset(
                      'assets/images/cancel.png',
                      width: 70,
                    ),
                  ),
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
          SizedBox(width: 4),
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
          bottom: MediaQuery.of(context).size.height - 110, left: 1, right: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
