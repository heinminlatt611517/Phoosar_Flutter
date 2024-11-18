import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phoosar/src/features/chat/liked_you_rooms_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:sized_context/sized_context.dart';

class LikedYouView extends ConsumerWidget {
  const LikedYouView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedYouList = ref.watch(likedYouListProvider(context));
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(kMarginMedium2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///blur grid image view
            likedYouList.when(
              data: (data) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(kMarginMedium2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: LikedYouRoomsScreen(
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
                return Container(
                    height: context.heightPx * 0.5,
                    child: Center(child:  SpinKitThreeBounce(color: Colors.pinkAccent,)));
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
