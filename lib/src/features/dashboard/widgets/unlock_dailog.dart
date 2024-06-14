import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/common_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/unlock_success_dailog.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

class UnlockDailog extends StatelessWidget {
  const UnlockDailog({super.key, required this.heartCount});
  final String heartCount;

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Unlock Feature',
      width: 400,
      isExpand: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.vGap,
            Center(
              child: Container(
                width: 80,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.heart_broken,
                      size: 24,
                      color: Colors.red,
                    ),
                    4.hGap,
                    Text(
                      heartCount,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: whiteColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.vGap,
            InkWell(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => UnlockSuccessDailog());
              },
              child: Text(
                'UNLOCK',
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  color: blueColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
