import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/common_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/rewind_row.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class GetMoreRewindsDialog extends StatelessWidget {
  const GetMoreRewindsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Get More Rewinds',
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
            RewindRow(rewindCount: '5', heartCount: '25'),
            12.vGap,
            Divider(
              height: 1,
              color: greyColor,
            ),
            12.vGap,
            RewindRow(rewindCount: '10', heartCount: '50'),
            12.vGap,
            Divider(
              height: 1,
              color: greyColor,
            ),
            12.vGap,
            RewindRow(rewindCount: '20', heartCount: '100'),
            12.vGap,
            Divider(
              height: 1,
              color: greyColor,
            ),
            12.vGap,
            RewindRow(rewindCount: '40', heartCount: '200'),
            30.vGap,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'UNLIMITED',
                  style: GoogleFonts.roboto(
                    fontSize: largeFontSize,
                    color: blueColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                8.hGap,
                Text(
                  'Rewinds',
                  style: GoogleFonts.roboto(
                    fontSize: mediumLargeFontSize,
                    color: blueColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
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
