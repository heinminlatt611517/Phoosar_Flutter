import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key, required this.text, required this.onTap, this.fontSize = 12});
  final String text;
  final Function() onTap;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: fontSize ?? 12,
            color: whiteColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
