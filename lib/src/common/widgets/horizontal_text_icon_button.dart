import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';

class HorizontalTextIconButton extends StatelessWidget {
  const HorizontalTextIconButton({
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kMarginMedium),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromRGBO(0, 0, 0, 0),
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1)),
      child: Row(
        children: [
          Bounceable(
            scaleFactor: 0.5,
            onTap: onTap,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: kMarginMedium),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: backgroundColor ?? whiteColor),
                    color: backgroundColor),
                child: icon),
          ),
          Text(text,
              style: GoogleFonts.roboto(
                fontSize: smallFontSize,
                color: blackColor,
                fontWeight: FontWeight.w200,
              )),
        ],
      ),
    );
  }
}
