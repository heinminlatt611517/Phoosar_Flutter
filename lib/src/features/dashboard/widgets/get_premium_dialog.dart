import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/common_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_more_rewinds_dialog.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class GetPremiumDialog extends StatelessWidget {
  const GetPremiumDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Get Phoosar Preminum',
      width: 400,
      isExpand: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/phoosar_premium_img.png',
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            20.vGap,
            Text(
              'See who likes you',
              style: GoogleFonts.roboto(
                fontSize: smallLargeFontSize,
                color: blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'And many more preminum features',
              style: GoogleFonts.roboto(
                fontSize: smallFontSize,
                color: greyColor,
              ),
            ),
            20.vGap,
            Align(
              alignment: Alignment.center,
              child: CommonButton(
                text: "CONTINUE",
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) => GetMoreRewindsDialog());
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
