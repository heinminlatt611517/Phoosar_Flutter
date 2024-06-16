import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';

class CommonTextFormField extends StatelessWidget {
  CommonTextFormField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.maxLines})
      : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: whitePaleColor),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: maxLines, // Makes it grow vertically
        decoration: InputDecoration(
          border: InputBorder.none, // Removes underline
          hintText: hintText,
          hintStyle: GoogleFonts.roboto(
            fontSize: smallFontSize,
            color: greyColor,
          ),
        ),
      ),
    );
  }
}
