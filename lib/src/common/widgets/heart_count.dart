import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class HeartCount extends StatelessWidget {
  const HeartCount({
    super.key,
    required this.heartCount,
    this.backgroundColor = primaryColor,
  });

  final String heartCount;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.heart_broken,
            size: 15,
            color: Colors.red,
          ),
          4.hGap,
          Text(
            heartCount,
            style: GoogleFonts.roboto(
              fontSize: smallFontSize,
              color: backgroundColor != primaryColor ? blackColor : whiteColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
