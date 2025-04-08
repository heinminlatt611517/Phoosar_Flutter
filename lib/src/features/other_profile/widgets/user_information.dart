import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/info_row.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/utils.dart';


class UserInformation extends StatelessWidget {
  const UserInformation({
    super.key,
    required this.findData,
    this.isShowAboutText
  });
  final ProfileData findData;
  final bool? isShowAboutText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              style: TextStyle(
                fontSize: smallFontSize,
                color: blackColor,
                fontFamily: kFontArticulatCFLight,
              ),
            ),
          ],
        ),
        4.hGap,
        Row(
          children: [
            Text(
              findData.name ?? '',
              style: TextStyle(
                fontSize: largeFontSize,
                color: blackColor,
                fontFamily: kFontArticulatCFBold,
              ),
            ),
            12.hGap,
            Visibility(
               visible: findData.showAge!.showAgeStatus! == true ? false : true,
              child: Text(
                Utils.calculateAge(findData.birthdate ?? ''),
                style: TextStyle(
                  fontSize: smallLargeFontSize,
                  color: blackColor,
                  fontFamily: kFontArticulatCFLight
                ),
              ),
            ),
          ],
        ),
        8.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/location.png',
            width: 10,
            color: blackColor,
          ),
          isOtherProfile : true,
          text: findData.city ?? '' + ' km away',
          textColor: blackColor,
        ),
        6.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/work.png',
            width: 12,
            color: blackColor,
          ),
          isOtherProfile : true,
          text: findData.jobTitle ?? '',
          textColor: blackColor,
        ),
        6.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/address.png',
            width: 12,
            color: blackColor,
          ),
          isOtherProfile : true,
          text: 'Live in ${findData.city ?? ''}',
          textColor: blackColor,
        ),
        6.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/school.png',
            width: 12,
            color: blackColor,
          ),
          isOtherProfile : true,
          text: findData.school ?? '',
          textColor: blackColor,
        ),
        6.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/date.png',
            width: 12,
            color: blackColor,
          ),
          isOtherProfile : true,
          text: findData.birthdate ?? '',
          textColor: blackColor,
        ),
        6.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/smoke.png',
            width: 12,
            color: blackColor,
          ),
          isOtherProfile : true,
          text: findData.smoke == "1" ? "Yes" : "No",
          textColor: blackColor,
        ),
        8.vGap,
        Visibility(
          visible: isShowAboutText ?? true,
          child: Divider(
            height: 1,
            color: greyColor,
          ),
        ),
        20.vGap,
        Visibility(
          visible: isShowAboutText ?? true,
          child: Text(
            findData.about ?? "",
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
              fontSize: smallFontSize,
              color: blackColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
