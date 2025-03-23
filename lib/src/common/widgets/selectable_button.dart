import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/extensions.dart';
import 'package:phoosar/src/utils/fonts.dart';

import '../../utils/dimens.dart';

class SelectableButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(String) onTapButton;
  final Color? bgColor;
  final String? initialBgColor;
  final String? labelColor;
  final Color? borderColor;
  final double? borderRadius;

  const SelectableButton(
      {super.key,
      required this.label,
      this.bgColor,
      required this.isSelected,
      required this.onTapButton,
      this.initialBgColor,
      this.labelColor,
      this.borderColor,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapButton(label);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: kMargin12),
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? borderColor ?? primaryColor : Colors.black, width: 1.5),
            color: isSelected
                ? bgColor ?? Colors.black
                : initialBgColor?.toColor(),
            borderRadius: BorderRadius.circular(borderRadius ?? kMarginMedium)),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isSelected
                    ? Colors.white
                    : labelColor == null
                    ? Colors.black
                    : labelColor?.toColor()
            ),
          ),
        ),
      ),
    );
  }
}
