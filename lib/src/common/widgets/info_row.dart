import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

class UserInfoRow extends StatelessWidget {
  const UserInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.textSize = 12,
    this.textColor = whiteColor,
  });
  final Widget icon;
  final String text;
  final double textSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        6.hGap,
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: textSize,
              color: textColor,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ],
    );
  }
}
