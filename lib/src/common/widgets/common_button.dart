import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.fontSize = 16,
      this.containerVPadding,
      this.containerHPadding,
      this.isLoading = false,
        this.isShowBorderColor = false,
      this.bgColor,
      this.buttonTextColor});
  final String text;
  final Function() onTap;
  final double? fontSize;
  final Color? bgColor;
  final double? containerVPadding;
  final double? containerHPadding;
  final bool isLoading;
  final bool? isShowBorderColor;
  final Color? buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: containerHPadding ?? 24,
            vertical: containerVPadding ?? 6),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.blue,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color:isShowBorderColor==true ? Colors.cyan : Colors.transparent,width: 1)
        ),
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('processing',
                      style: const TextStyle(color: Colors.black)),
                  const SpinKitThreeBounce(size: 25, color: Colors.black),
                ],
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: fontSize ?? smallFontSize,
                  color:buttonTextColor ?? whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
