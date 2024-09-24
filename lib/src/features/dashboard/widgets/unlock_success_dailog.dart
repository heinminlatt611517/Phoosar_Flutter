import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/common_dialog.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class UnlockSuccessDailog extends StatelessWidget {
  const UnlockSuccessDailog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: '',
      isLargeTitleSize: true,
      isUnlockDialog: true,
      width: 400,
      isExpand: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.vGap,
            Text(
              'Unlocked',
              style: GoogleFonts.roboto(
                color: greyColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            20.vGap,
            Align(
              alignment: Alignment.center,
              child: CommonButton(
                fontSize: mediumFontSize,
                bgColor: primaryColor,
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
