import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/info_row.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class UserInformation extends StatelessWidget {
  const UserInformation({
    super.key,
    required this.findData,
  });
  final ProfileData findData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.circle,
              color:findData.isOnline == 1 ? Colors.green : Colors.red,
              size: 10,
            ),
            4.hGap,
            Text(
             findData.isOnline == 1 ? AppLocalizations.of(context)!.kOnlineLabel : AppLocalizations.of(context)!.kOfflineLabel,
              style: GoogleFonts.roboto(
                fontSize: smallFontSize,
                color: blackColor,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
        4.hGap,
        Row(
          children: [
            Text(
              findData.name ?? '',
              style: GoogleFonts.roboto(
                fontSize: largeFontSize,
                color: blackColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            12.hGap,
            Visibility(
               visible: findData.showAge!.showAgeStatus! == true ? false : true,
              child: Text(
                findData.birthdate ?? '',
                style: GoogleFonts.roboto(
                  fontSize: smallLargeFontSize,
                  color: blackColor,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ],
        ),
        8.vGap,
        UserInfoRow(
          icon: Icon(
            Icons.location_on,
            color: blackColor,
            size: 14,
          ),
          text: findData.city ?? '' + ' km away',
          textColor: blackColor,
        ),
        UserInfoRow(
          icon: Icon(
            Icons.work,
            color: blackColor,
            size: 14,
          ),
          text: findData.jobTitle ?? '',
          textColor: blackColor,
        ),
        UserInfoRow(
          icon: Icon(
            Icons.home,
            color: blackColor,
            size: 14,
          ),
          text: 'Live in ${findData.city ?? ''}',
          textColor: blackColor,
        ),
        UserInfoRow(
          icon: Icon(
            Icons.school,
            color: blackColor,
            size: 14,
          ),
          text: findData.school ?? '',
          textColor: blackColor,
        ),
        UserInfoRow(
          icon: Icon(
            Icons.calendar_month,
            color: blackColor,
            size: 14,
          ),
          text: findData.birthdate ?? '',
          textColor: blackColor,
        ),
        UserInfoRow(
          icon: Icon(
            Icons.smoke_free,
            color: blackColor,
            size: 14,
          ),
          text: findData.smoke == "1" ? "Yes" : "No",
          textColor: blackColor,
        ),
        8.vGap,
        Divider(
          height: 1,
          color: greyColor,
        ),
        20.vGap,
        Text(
          findData.about ?? "",
          textAlign: TextAlign.left,
          style: GoogleFonts.roboto(
            fontSize: smallFontSize,
            color: blackColor,
            fontWeight: FontWeight.w100,
          ),
        ),
      ],
    );
  }
}
