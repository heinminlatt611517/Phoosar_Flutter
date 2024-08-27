import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/common_dialog.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class ReportSuccessDailog extends StatelessWidget {
  const ReportSuccessDailog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Profile Report saved successfully.',
      width: 400,
      isExpand: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.vGap,
            Center(
              child: Icon(
                Icons.check,
                size: 60,
                color: primaryColor,
              ),
            ),
            20.vGap,
            Align(
              alignment: Alignment.center,
              child: CommonButton(
                fontSize: mediumFontSize,
                text: "CONTINUE",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            12.vGap,
          ],
        ),
      ),
    );
  }
}
