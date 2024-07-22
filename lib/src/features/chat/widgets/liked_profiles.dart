import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                return GridView.builder(
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
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                              ),
                            ),
                          );
                  },
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // number of items in each row
                    mainAxisSpacing: 18.0, // spacing between rows
                    crossAxisSpacing: 8.0, // spacing between columns
                  ),
                );
              },
              error: (error, stack) {
                return Text(error.toString());
              },
              loading: () {
                return const CircularProgressIndicator();
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
