import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';

class UserInfoRow extends StatelessWidget {
  const UserInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.textSize = 14,
    this.textColor = whiteColor,
    this.isOtherProfile = false
  });
  final Widget icon;
  final String text;
  final double textSize;
  final Color textColor;
  final bool isOtherProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        6.hGap,
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: textSize,
              color: textColor,
              fontFamily:isOtherProfile == true ? kFontArticulatCFMedium : kFontArticulatCFLight,
              fontWeight:isOtherProfile == true ? FontWeight.w400 : FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
