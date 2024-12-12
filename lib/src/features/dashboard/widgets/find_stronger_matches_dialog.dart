import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/common_dialog.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FindStrongerMatchesDialog extends StatelessWidget {
  const FindStrongerMatchesDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: '',
      width: 400,
      isExpand: true,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ic_launcher.png',
                height: 60,
              ),
              10.vGap,
              Text(
                'Find stronger matches!',
                style: GoogleFonts.roboto(
                  fontSize: largeFontSize,
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.vGap,
              Text(
                'Answer the following questions to\ncomplete your profile.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: smallFontSize,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),

              40.vGap,

              CommonButton(
                  bgColor: Colors.pinkAccent,
                  text: AppLocalizations.of(context)!.kContinueLabel, onTap: (){}),

              40.vGap,
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
