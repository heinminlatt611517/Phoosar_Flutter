import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/widgets/liked_profiles.dart';
import 'package:phoosar/src/features/chat/widgets/liked_you.dart';
import 'package:phoosar/src/features/chat/widgets/matches.dart';
import 'package:phoosar/src/utils/gap.dart';
import '../../providers/data_providers.dart';
import '../../utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
    var selfProfileData = ref.watch(selfProfileProvider);
    return Scaffold(
      backgroundColor: whitePaleColor,
      appBar: AppBar(
        backgroundColor: whitePaleColor,
        centerTitle: true,
        title: Text(
         selectedIndex == 0 ? AppLocalizations.of(context)!.kMatchesLabel : selectedIndex == 1 ? AppLocalizations.of(context)!.kLikedYouLabel : AppLocalizations.of(context)!.kLikedProfilesLabel,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
        ),
        actions: [
          // TextButton(
          //   onPressed: () async {
          //     await supabase.auth.signOut();
          //
          //     Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(builder: (context) => RegisterScreen()),
          //       (route) => false,
          //     );
          //   },
          //   child: const Text('Logout'),
          // ),
        ],
      ),
      body: Column(
        children: [
          ///match and like you view
          MatchAndLikeYouView(
            selectedIndex: selectedIndex,
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
          // Visibility(
          //   visible: selectedIndex == 0,
          //   child: Expanded(
          //     child: Padding(
          //       padding: const EdgeInsets.all(kMarginMedium2),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           ///new match horizontal list

          //           Expanded(child: RoomsScreen())
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          //Matches View
          Visibility(
            visible: selectedIndex == 0,
            child: MatchesView(),
          ),

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
  final int selectedIndex;
  const MatchAndLikeYouView(
      {super.key,
      required this.onTapMatches,
      required this.onTapLikedYou,
      required this.onTapLikedProfiles,required this.selectedIndex});

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
                      'Matches',//AppLocalizations.of(context)!.kMatchesLabel,
                      style: TextStyle(color:selectedIndex == 0 ? Colors.pinkAccent : Colors.grey, fontSize: 16),
                    ),

                    ///spacer
                    5.hGap,

                    ///red circle indicator
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
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
                      'Liked You',//AppLocalizations.of(context)!.kLikedYouLabel,
                      style: TextStyle(color: selectedIndex == 1 ? Colors.pinkAccent : Colors.grey, fontSize: 16),
                    ),

                    ///spacer
                    5.hGap,

                    ///red circle indicator
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
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
                      'Liked Profiles',//AppLocalizations.of(context)!.kLikedProfilesLabel,
                      style: TextStyle(color: selectedIndex == 2 ? Colors.pinkAccent : Colors.grey, fontSize: 16),
                    ),

                    ///spacer
                    5.hGap,

                    ///red circle indicator
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
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
