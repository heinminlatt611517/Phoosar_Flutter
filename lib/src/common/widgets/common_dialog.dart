import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';

class CommonDialog extends StatelessWidget {
  const CommonDialog(
      {super.key,
      required this.title,
      required this.width,
      required this.child,
      this.height,
      this.isExpand = false,
      this.isLargeTitleSize = false,
      this.isUnlockDialog = false,
      this.isCustomFont = false,
        this.isUnlockFeature = false,
      this.titleColor,
      this.backgroundColor,
      this.titleFontSize});

  final String title;
  final Widget child;
  final double width;
  final double? height;
  final bool? isLargeTitleSize;
  final bool isExpand;
  final bool? isUnlockDialog;
  final bool? isUnlockFeature;
  final bool? isCustomFont;
  final Color? titleColor;
  final Color? backgroundColor;
  final double? titleFontSize;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          color:backgroundColor ?? whitePaleColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
           isUnlockFeature ==true ? 30.vGap : 20.vGap,
            Center(
              child: isUnlockDialog == true
                  ? Image.asset(
                'assets/images/unlocked.png',
                height: 80,
                fit: BoxFit.cover,
              )
                  : Text(
                      title,
                       textAlign: TextAlign.center,
                      style:isCustomFont == true ? TextStyle(
                        fontSize:titleFontSize ?? 26,
                        fontFamily: kFontArticulatCFBold,
                        color:titleColor ?? orangeColor,
                        fontWeight: FontWeight.bold,
                      ) : GoogleFonts.roboto(
                        color:titleColor ?? greyColor,
                        fontSize:
                            isLargeTitleSize == true ? 24 : smallLargeFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            Flexible(
              flex: isExpand ? 1 : 0,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 30), child: child),
            ),
          ],
        ),
      ),
    );
  }
}
