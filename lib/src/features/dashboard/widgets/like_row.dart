import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/features/dashboard/widgets/unlock_dailog.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';
import '../../../localization/app_localizations.dart';

import '../../../utils/dimens.dart';

class LikeRow extends StatelessWidget {
  const LikeRow(
      {super.key,
      required this.likeCount,
      required this.heartCount,
      required this.buyId});

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
                style: TextStyle(
                  fontSize: mediumFontSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: blackColor, width: 1.5)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/update_coin.png',
                      height: 16,
                      fit: BoxFit.cover,
                    ),
                    4.hGap,
                    Text(
                      heartCount,
                      style: GoogleFonts.roboto(
                        fontSize: smallFontSize,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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
                child: Text(AppLocalizations.of(context)!.kUnlockLabel,
                    style: TextStyle(
                      fontFamily: kFontGibsonBold,
                      fontSize: 16,
                      color: greenColor,
                    )),
              ),
              10.hGap,
            ],
          ),
        ],
      ),
    );
  }
}
