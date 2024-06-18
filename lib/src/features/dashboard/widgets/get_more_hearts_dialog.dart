import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/common_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/heart_row.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class GetMoreHeartsDialog extends StatelessWidget {
  const GetMoreHeartsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Get More Hearts',
      width: 400,
      isExpand: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            12.vGap,
            Divider(
              height: 1,
              color: greyColor,
            ),
            12.vGap,
            HeartRow(likeHeartCount: '5', heartCount: '25'),
            12.vGap,
            Divider(
              height: 1,
              color: greyColor,
            ),
            12.vGap,
            HeartRow(likeHeartCount: '10', heartCount: '50'),
            12.vGap,
            Divider(
              height: 1,
              color: greyColor,
            ),
            12.vGap,
            HeartRow(likeHeartCount: '20', heartCount: '100'),
            12.vGap,
            Divider(
              height: 1,
              color: greyColor,
            ),
            12.vGap,
            HeartRow(likeHeartCount: '40', heartCount: '200'),
            30.vGap,
            Center(
              child: Text(
                'UNLIMITED Hearts',
                style: GoogleFonts.roboto(
                  fontSize: largeFontSize,
                  color: blueColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            12.vGap,
            Align(
              alignment: Alignment.center,
              child: CommonButton(
                fontSize: mediumFontSize,
                text: "PHOOSAR PREMINUM",
                onTap: () {},
              ),
            ),
            12.vGap,
          ],
        ),
      ),
    );
  }
}
