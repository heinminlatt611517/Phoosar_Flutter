import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.fontSize = 12,
      this.containerVPadding,
      this.containerHPadding,
      this.bgColor});
  final String text;
  final Function() onTap;
  final double? fontSize;
  final Color? bgColor;
  final double? containerVPadding;
  final double? containerHPadding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: containerHPadding ?? 24,
            vertical: containerVPadding ?? 6),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: fontSize ?? smallFontSize,
            color: whiteColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
