import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/info_row.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/features/dashboard/widgets/dashboard_user_slider.dart';
import 'package:phoosar/src/features/other_profile/other_profile.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phoosar/src/utils/utils.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.findData});
  final ProfileData findData;

  @override
  Widget build(BuildContext context) {
    log(findData.profileImages.toString());
    return Container(
      height: MediaQuery.of(context).size.height * 0.67,
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Stack(
        children: [
          DashboardProfileSlider(
            score: findData.score ?? 0,
            profileImages: (findData.profileImages == null ||
                    findData.profileImages!.isEmpty)
                ? [errorImageUrl]
                : findData.profileImages ?? [],
          ),
          Positioned(
            bottom: 32,
            left: 32,
            right: 24,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(findData: findData)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color:
                            findData.isOnline == 1 ? Colors.green : Colors.red,
                        size: 12,
                      ),
                      4.hGap,
                      Text(
                        findData.isOnline == 1
                            ? AppLocalizations.of(context)!.kOnlineLabel
                            : AppLocalizations.of(context)!.kOfflineLabel,
                        style: GoogleFonts.roboto(
                          fontSize: smallFontSize,
                          color: whiteColor,
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
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      12.hGap,
                      Text(
                        Utils.calculateAge(findData.birthdate ?? ''),
                        style: GoogleFonts.roboto(
                          fontSize: mediumLargeFontSize,
                          color: whiteColor,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                  8.vGap,
                  UserInfoRow(
                    icon: Icon(
                      Icons.location_on,
                      color: whiteColor,
                      size: 14,
                    ),
                    text: findData.city ?? '',
                  ),
                  UserInfoRow(
                    icon: Icon(
                      Icons.work,
                      color: whiteColor,
                      size: 14,
                    ),
                    text: findData.jobTitle ?? '',
                  ),
                  UserInfoRow(
                    icon: Icon(
                      Icons.home,
                      color: whiteColor,
                      size: 14,
                    ),
                    text: 'Live in ${findData.city ?? ''}',
                  ),
                  UserInfoRow(
                    icon: Icon(
                      Icons.school,
                      color: whiteColor,
                      size: 14,
                    ),
                    text: findData.school ?? '',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
