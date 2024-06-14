import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/info_row.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

class UserInformation extends StatelessWidget {
  const UserInformation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.circle,
              color: Colors.green,
              size: 10,
            ),
            4.hGap,
            Text(
              'Online',
              style: GoogleFonts.roboto(
                fontSize: 11,
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
              'Julia',
              style: GoogleFonts.roboto(
                fontSize: 22,
                color: blackColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            12.hGap,
            Text(
              '30',
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: blackColor,
                fontWeight: FontWeight.w200,
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
          text: '6 km away',
          textColor: blackColor,
        ),
        UserInfoRow(
          icon: Icon(
            Icons.work,
            color: blackColor,
            size: 14,
          ),
          text: 'Software Engineer',
          textColor: blackColor,
        ),
        UserInfoRow(
          icon: Icon(
            Icons.home,
            color: blackColor,
            size: 14,
          ),
          text: 'Live in Yangon',
          textColor: blackColor,
        ),
        UserInfoRow(
          icon: Icon(
            Icons.school,
            color: blackColor,
            size: 14,
          ),
          text: 'University of Computer Studies (Yangon)',
          textColor: blackColor,
        ),
        UserInfoRow(
          icon: Icon(
            Icons.calendar_month,
            color: blackColor,
            size: 14,
          ),
          text: 'Sunday',
          textColor: blackColor,
        ),
        UserInfoRow(
          icon: Icon(
            Icons.smoke_free,
            color: blackColor,
            size: 14,
          ),
          text: 'No',
          textColor: blackColor,
        ),
        8.vGap,
        Divider(
          height: 1,
          color: greyColor,
        ),
        20.vGap,
        Text(
          'Work hard, be kind, amazing things in life. Love dancing,singing,reading and generally have a good time.',
          textAlign: TextAlign.left,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: blackColor,
            fontWeight: FontWeight.w100,
          ),
        ),
      ],
    );
  }
}
