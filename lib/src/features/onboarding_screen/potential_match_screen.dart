import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/selectable_button.dart';
import '../../utils/dimens.dart';

class PotentialMatchScreen extends StatefulWidget {
  const PotentialMatchScreen({super.key});

  @override
  State<PotentialMatchScreen> createState() => _PotentialMatchScreenState();
}

class _PotentialMatchScreenState extends State<PotentialMatchScreen> {
  var selectedText = "";
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
                kWhereWouldYouLikeToMeet,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: kTextRegular24),
              ),
              80.vGap,

              ///selectable button
              SelectableButton(
                  label: kAtAParkLabel,
                  isSelected: selectedText == kAtAParkLabel,
                  onTapButton: (value) {
                    setState(() {
                      selectedText = value;
                    });
                  }),

              20.vGap,

              SelectableButton(
                  label: kAtACoffeeShop,
                  isSelected: selectedText == kAtACoffeeShop,
                  onTapButton: (value) {
                    setState(() {
                      selectedText = value;
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
