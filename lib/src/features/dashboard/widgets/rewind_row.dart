import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/coin_count.dart';
import 'package:phoosar/src/common/widgets/heart_count.dart';
import 'package:phoosar/src/features/dashboard/widgets/unlock_dailog.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class RewindRow extends StatelessWidget {
  const RewindRow(
      {super.key, required this.rewindCount, required this.heartCount,required this.buyId});
  final String rewindCount;
  final String heartCount;
  final String buyId;

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
                width: 40,
                child: Text(
                  rewindCount,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.roboto(
                    fontSize: mediumFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                ' Rewinds',
                style: GoogleFonts.roboto(
                  fontSize: mediumFontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            children: [
              CoinCount(coinCount: heartCount),
              10.hGap,
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) =>
                          UnlockDailog(heartCount: heartCount,buyId: buyId,));
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
