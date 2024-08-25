import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/match_rooms_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:sized_context/sized_context.dart';

class MatchesView extends ConsumerWidget {
  const MatchesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchListList = ref.watch(matchListProvider(context));
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///blur grid image view
            matchListList.when(
              data: (data) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(kMarginMedium2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: MatchRoomsScreen(
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
                    child: Center(child: const CircularProgressIndicator()));
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
