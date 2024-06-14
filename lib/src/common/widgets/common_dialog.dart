import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

class CommonDialog extends StatelessWidget {
  const CommonDialog({
    super.key,
    required this.title,
    required this.width,
    required this.child,
    this.height,
    this.isExpand = false,
  });
  final String title;
  final Widget child;
  final double width;
  final double? height;

  final bool isExpand;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            20.vGap,
            Center(
              child: Text(
                title,
                style: GoogleFonts.roboto(
                  color: greyColor,
                  fontSize: 18,
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
