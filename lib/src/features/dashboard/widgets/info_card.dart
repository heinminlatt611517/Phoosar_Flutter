import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/info_row.dart';
import 'package:phoosar/src/features/dashboard/widgets/dashboard_user_slider.dart';
import 'package:phoosar/src/features/other_profile/other_profile.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.67,
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Stack(
        children: [
          DashboardProfileSlider(),
          Positioned(
            bottom: 32,
            left: 32,
            right: 24,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 12,
                      ),
                      4.hGap,
                      Text(
                        'Online',
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
                        'Julia',
                        style: GoogleFonts.roboto(
                          fontSize: largeFontSize,
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      12.hGap,
                      Text(
                        '30',
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
                    text: '6 km away',
                  ),
                  UserInfoRow(
                    icon: Icon(
                      Icons.work,
                      color: whiteColor,
                      size: 14,
                    ),
                    text: 'Software Engineer',
                  ),
                  UserInfoRow(
                    icon: Icon(
                      Icons.home,
                      color: whiteColor,
                      size: 14,
                    ),
                    text: 'Live in Yangon',
                  ),
                  UserInfoRow(
                    icon: Icon(
                      Icons.school,
                      color: whiteColor,
                      size: 14,
                    ),
                    text: 'University of Computer Studies (Yangon)',
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
