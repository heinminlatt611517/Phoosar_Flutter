import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/extensions.dart';

import '../../utils/dimens.dart';

class SelectableButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(String) onTapButton;
  final Color? bgColor;
  final String? initialBgColor;
  final String? labelColor;

  const SelectableButton(
      {super.key,
      required this.label,
      this.bgColor,
      required this.isSelected,
      required this.onTapButton,
      this.initialBgColor,
      this.labelColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapButton(label);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: kMarginMedium2),
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? primaryColor : Colors.black, width: 1),
            color: isSelected
                ? bgColor ?? Colors.black
                : initialBgColor?.toColor(),
            borderRadius: BorderRadius.circular(kMarginMedium)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : labelColor == null
                        ? Colors.black
                        : labelColor?.toColor()),
          ),
        ),
      ),
    );
  }
}
