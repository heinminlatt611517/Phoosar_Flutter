import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class CommonTextIconButton extends StatelessWidget {
  const CommonTextIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
    this.backgroundColor = whiteColor,
  });
  final Function() onTap;
  final Widget icon;
  final String text;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Bounceable(
          scaleFactor: 0.5,
          onTap: onTap,
          child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: backgroundColor ?? whiteColor),
                  color: backgroundColor),
              child: icon),
        ),
        12.vGap,
        Text(text,
            style: GoogleFonts.roboto(
              fontSize: smallFontSize,
              color: blackColor,
              fontWeight: FontWeight.w200,
            )),
      ],
    );
  }
}
