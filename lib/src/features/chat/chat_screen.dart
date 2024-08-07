import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/auth/register.dart';
import 'package:phoosar/src/features/chat/rooms_screen.dart';
import 'package:phoosar/src/features/chat/widgets/liked_profiles.dart';
import 'package:phoosar/src/features/chat/widgets/liked_you.dart';
import 'package:phoosar/src/features/chat/widgets/matches.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import '../../utils/colors.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatState();
}

class _ChatState extends ConsumerState<ChatScreen> {
  int selectedIndex = 0;
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
                MaterialPageRoute(builder: (context) => RegisterScreen()),
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
            onTapMatches: () {
              setState(() {
                selectedIndex = 0;
              });
            },
            onTapLikedYou: () {
              setState(() {
                selectedIndex = 1;
              });
            },
            onTapLikedProfiles: () {
              setState(() {
                selectedIndex = 2;
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

          //new matches view
          Visibility(
            visible: selectedIndex == 0,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kMarginMedium2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///new match horizontal list

                    Expanded(child: RoomsScreen())
                  ],
                ),
              ),
            ),
          ),

          ///Matches View
          // Visibility(
          //   visible: selectedIndex == 0,
          //   child: MatchesView(),
          // ),

          ///liked you view
          Visibility(
            visible: selectedIndex == 1,
            child: LikedYouView(),
          ),

          ///liked profiles view
          Visibility(
            visible: selectedIndex == 2,
            child: LikedProfilesView(),
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
  final Function() onTapLikedProfiles;
  const MatchAndLikeYouView(
      {super.key,
      required this.onTapMatches,
      required this.onTapLikedYou,
      required this.onTapLikedProfiles});

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

              Container(width: 0.5, height: 40, color: Colors.grey),

              ///Liked you
              InkWell(
                onTap: onTapLikedProfiles,
                child: Row(
                  children: [
                    Text(
                      "Liked Profiles",
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
