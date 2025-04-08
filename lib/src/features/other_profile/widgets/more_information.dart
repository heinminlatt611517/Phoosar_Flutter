import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/fonts.dart';
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
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: blackColor,width: 1),borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: kMarginMedium),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: mediumFontSize,
                color: blackColor,
                fontFamily: kFontGibsonBold,
                fontWeight: FontWeight.w300,
              ),
            ),
            8.vGap,
            Text(
              description,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: smallFontSize,
                color: blackColor,
                fontFamily: kFontArticulatCFNormal,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
