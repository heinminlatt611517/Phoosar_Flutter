import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/auth/register.dart';
import 'package:phoosar/src/features/chat/rooms_screen.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_more_likes_dialog.dart';
import 'package:phoosar/src/list_items/message_list_item_view.dart';
import 'package:phoosar/src/settings/settings_controller.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/common_button.dart';
import '../../utils/colors.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatState();
}

class _ChatState extends ConsumerState<ChatScreen> {
  bool isMatched = true;
  bool isLikedYou = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitePaleColor,
      appBar: AppBar(
        backgroundColor: whitePaleColor,
        leading: Icon(Icons.arrow_back_ios_new, color: Colors.black45),
        centerTitle: true,
        title: Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await supabase.auth.signOut();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => RegisterScreen(
                        )),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: Column(
        children: [
          ///match and like you view
          MatchAndLikeYouView(
            onTapLikedYou: () {
              setState(() {
                isMatched = false;
                isLikedYou = !isLikedYou;
              });
            },
            onTapMatches: () {
              setState(() {
                isMatched = !isMatched;
                isLikedYou = false;
              });
            },
          ),

          ///messages list item view
          // Visibility(
          //   visible: isMatched || isLikedYou ? false : true,
          //   child: Expanded(
          //     child: ListView.builder(
          //       shrinkWrap: true,
          //       itemBuilder: (context, index) {
          //         return MessageListItemView();
          //       },
          //       itemCount: 8,
          //     ),
          //   ),
          // ),

          ///new matches view
          Visibility(
            visible: isMatched ? true : false,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kMarginMedium2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///new match horizontal list

                    Expanded(
                        child:
                            RoomsScreen())
                  ],
                ),
              ),
            ),
          ),

          ///liked you view
          Visibility(
            visible: isLikedYou ? true : false,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kMarginMedium2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///blur grid image view
                    GridView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return index == 0
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  "assets/images/sample_profile.png",
                                  width: 100,
                                  height: 125,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                height: 200,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: ExactAssetImage(
                                        "assets/images/sample_profile2.jpeg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.grey.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              );
                      },
                      itemCount: 6,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // number of items in each row
                        mainAxisSpacing: 18.0, // spacing between rows
                        crossAxisSpacing: 8.0, // spacing between columns
                      ),
                    ),

                    80.vGap,
                    Text(
                      "Want to see who else liked\nyour profile?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: kTextRegular22, color: Colors.grey),
                    ),
                    20.vGap,
                    CommonButton(
                      text: "CONTINUE",
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => GetMoreLikesDialog());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///match and like you view
class MatchAndLikeYouView extends StatelessWidget {
  final Function() onTapMatches;
  final Function() onTapLikedYou;
  const MatchAndLikeYouView(
      {super.key, required this.onTapMatches, required this.onTapLikedYou});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 55,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey, width: 0.2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ///matches
              InkWell(
                onTap: onTapMatches,
                child: Row(
                  children: [
                    Text(
                      "Matches",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),

                    ///spacer
                    5.hGap,

                    ///red circle indicator
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4)),
                    )
                  ],
                ),
              ),

              ///vertical divider
              Container(width: 0.5, height: 40, color: Colors.grey),

              ///Liked you
              InkWell(
                onTap: onTapLikedYou,
                child: Row(
                  children: [
                    Text(
                      "Liked You",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),

                    ///spacer
                    5.hGap,

                    ///red circle indicator
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4)),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
