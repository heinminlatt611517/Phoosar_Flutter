import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/selectable_button.dart';
import '../../utils/dimens.dart';

class RelationshipScreen extends StatefulWidget {
  const RelationshipScreen({super.key});

  @override
  State<RelationshipScreen> createState() => _RelationshipScreenState();
}

class _RelationshipScreenState extends State<RelationshipScreen> {
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
                kWhatAreYouLookingForInARelationship,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: kTextRegular24),
              ),
              80.vGap,

              ///selectable button
              SelectableButton(
                  label: kCasualDatingLabel,
                  isSelected: selectedText == kCasualDatingLabel,
                  onTapButton: (value) {
                    setState(() {
                      selectedText = value;
                    });
                  }),

              20.vGap,

              SelectableButton(
                  label: kMarriageLabel,
                  isSelected: selectedText == kMarriageLabel,
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
