import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/liked_profiles_rooms_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/dimens.dart';

class LikedProfilesView extends ConsumerWidget {
  const LikedProfilesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedProfilesList = ref.watch(likedProfilesListProvider(context));
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(kMarginMedium2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///blur grid image view
            likedProfilesList.when(
              data: (data) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(kMarginMedium2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: LikedProfilesRoomsScreen(
                          filterUsers: data,
                        ))
                      ],
                    ),
                  ),
                );
              },
              error: (error, stack) {
                return Text(error.toString());
              },
              loading: () {
                return Container();
              },
            ),

            // 80.vGap,
            // Text(
            //   "Want to see who else liked\nyour profile?",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: kTextRegular22, color: Colors.grey),
            // ),
            // 20.vGap,
            // CommonButton(
            //   text: "CONTINUE",
            //   onTap: () {
            //     showDialog(
            //         context: context,
            //         builder: (context) => GetMoreLikesDialog());
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
