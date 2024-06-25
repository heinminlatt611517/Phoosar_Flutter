import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../utils/dimens.dart';

class TypeOfPersonScreen extends StatefulWidget {
  const TypeOfPersonScreen({super.key});

  @override
  State<TypeOfPersonScreen> createState() => _TypeOfPersonScreenState();
}

class _TypeOfPersonScreenState extends State<TypeOfPersonScreen> {
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
                kWhatTypeOfPersonAreYou,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: kTextRegular24),
              ),
              80.vGap,

              ///selectable button
              SelectableButton(
                  label: kClamAndCollected,
                  isSelected: selectedText == kClamAndCollected,
                  onTapButton: (value) {
                    setState(() {
                      selectedText = value;
                    });
                  }),

              20.vGap,

              SelectableButton(
                  label: kChillAndLaidBack,
                  isSelected: selectedText == kChillAndLaidBack,
                  onTapButton: (value) {
                    setState(() {
                      selectedText = value;
                    });
                  }),
              20.vGap,

              SelectableButton(
                  label: kFunAndUnSerious,
                  isSelected: selectedText == kFunAndUnSerious,
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

///selectable button view
class SelectableButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(String) onTapButton;
  const SelectableButton(
      {super.key,
      required this.label,
      required this.isSelected,
      required this.onTapButton});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapButton(label);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: kMarginMedium2),
        decoration: BoxDecoration(
            color:
                isSelected ? Colors.pinkAccent : Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(kMarginMedium)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
