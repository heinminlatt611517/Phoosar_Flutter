import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class MoreInformation extends StatelessWidget {
  const MoreInformation({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: GoogleFonts.roboto(
            fontSize: mediumFontSize,
            color: blackColor,
            fontWeight: FontWeight.w300,
          ),
        ),
        8.vGap,
        Text(
          description,
          textAlign: TextAlign.left,
          style: GoogleFonts.roboto(
            fontSize: smallFontSize,
            color: blackColor,
            fontWeight: FontWeight.w100,
          ),
        ),
      ],
    );
  }
}
