import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../utils/dimens.dart';

class FillShortDescriptionScreen extends ConsumerStatefulWidget {
  const FillShortDescriptionScreen({super.key});

  @override
  ConsumerState<FillShortDescriptionScreen> createState() =>
      _FillShortDescriptionScreenState();
}

class _FillShortDescriptionScreenState
    extends ConsumerState<FillShortDescriptionScreen> {
  TextEditingController shortDescriptionTextController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(kMarginLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                kShortDescriptionAboutYou,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: kTextRegular24),
              ),
              20.vGap,

              ///short desc text form field
              TextFormField(
                  maxLines: 10,
                  controller: shortDescriptionTextController,
                  onChanged: (value) {
                    // ref.read(profileSaveRequestProvider.notifier).state.about =
                    //     value;
                  },
                  decoration: InputDecoration(
                    hintMaxLines: 2,
                    hintStyle: TextStyle(
                        fontSize: kTextRegular,
                        color: Colors.grey.withOpacity(0.8)),
                    hintText: kHowWouldYourFamilyOrBestFriendDescribeYou,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
