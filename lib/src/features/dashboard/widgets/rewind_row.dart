import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/coin_count.dart';
import 'package:phoosar/src/common/widgets/heart_count.dart';
import 'package:phoosar/src/features/dashboard/widgets/unlock_dailog.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';
import '../../../localization/app_localizations.dart';


class RewindRow extends StatelessWidget {
  const RewindRow(
      {super.key,
      required this.rewindCount,
      required this.heartCount,
      required this.buyId});
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
                style: TextStyle(
                  fontSize: mediumFontSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          Row(
            children: [
              CoinCount(coinCount: heartCount,backgroundColor: Colors.white,),
              20.hGap,
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) => UnlockDailog(
                            heartCount: heartCount,
                            buyId: buyId,
                          ));
                },
                child: Text(
                  AppLocalizations.of(context)!.kUnlockLabel.toUpperCase(),
                  style: TextStyle(
                    fontSize: smallFontSize,
                    color: greenColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: kFontGibsonBold
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
