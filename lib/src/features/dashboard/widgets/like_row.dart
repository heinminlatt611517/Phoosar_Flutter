import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/features/dashboard/widgets/unlock_dailog.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class LikeRow extends StatelessWidget {
  const LikeRow({super.key, required this.likeCount, required this.heartCount});
  final String likeCount;
  final String heartCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  likeCount,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.roboto(
                    fontSize: mediumFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                ' Likes',
                style: GoogleFonts.roboto(
                  fontSize: mediumFontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.heart_broken,
                      size: 15,
                      color: Colors.red,
                    ),
                    4.hGap,
                    Text(
                      heartCount,
                      style: GoogleFonts.roboto(
                        fontSize: smallFontSize,
                        color: whiteColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              10.hGap,
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) =>
                          UnlockDailog(heartCount: heartCount));
                },
                child: Text(
                  'UNLOCK',
                  style: GoogleFonts.roboto(
                    fontSize: mediumFontSize,
                    color: blueColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              10.hGap,
            ],
          ),
        ],
      ),
    );
  }
}
