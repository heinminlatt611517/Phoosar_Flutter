import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/selectable_button.dart';
import '../../utils/dimens.dart';

class BirthdateScreen extends StatefulWidget {
  const BirthdateScreen({super.key});

  @override
  State<BirthdateScreen> createState() => _BirthdateScreenState();
}

class _BirthdateScreenState extends State<BirthdateScreen> {
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
                kDoYouCareBirthdate,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: kTextRegular24),
              ),
              80.vGap,

              ///selectable button
              SelectableButton(
                  label: kYesLabel,
                  isSelected: selectedText == kYesLabel,
                  onTapButton: (value) {
                    setState(() {
                      selectedText = value;
                    });
                  }),

              20.vGap,

              SelectableButton(
                  label: kNoLabel,
                  isSelected: selectedText == kNoLabel,
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
