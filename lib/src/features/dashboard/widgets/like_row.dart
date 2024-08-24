import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/features/dashboard/widgets/unlock_dailog.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LikeRow extends StatelessWidget {
  const LikeRow({super.key, required this.likeCount, required this.heartCount,required this.buyId});
  final String likeCount;
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
                    Image.asset(
                      'assets/images/coin.png',
                      height: 16,
                      fit: BoxFit.cover,
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
                          UnlockDailog(heartCount: heartCount,buyId: buyId,));
                },
                child: Text(
                  AppLocalizations.of(context)!.kUnlockLabel.toUpperCase(),
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
