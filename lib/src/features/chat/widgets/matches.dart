import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/features/chat/match_rooms_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/app_provider.dart';


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
                    child:data.isEmpty ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        Text('No Matches Yet!',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey.withOpacity(0.5),fontSize: 18),),
                          20.vGap,
                          CommonButton(
                            bgColor: Colors.pinkAccent,
                              text: AppLocalizations.of(context)!.kContinueLabel, onTap: (){
                            ref.read(dashboardProvider.notifier).setPosition(0);
                          })
                      ],),
                    ) : Column(
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
