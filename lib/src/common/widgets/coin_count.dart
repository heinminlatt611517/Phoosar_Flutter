import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';

class CoinCount extends StatelessWidget {
  const CoinCount({
    super.key,
    required this.coinCount,
    this.backgroundColor = primaryColor,
    this.width,
  });

  final String coinCount;
  final Color backgroundColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black,width: 1.5)
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/update_coin.png',
            height: 16,
            fit: BoxFit.cover,
          ),
          4.hGap,
          Text(
            coinCount,
            style:TextStyle(
              fontSize: smallFontSize,
              color: backgroundColor != primaryColor ? blackColor : whiteColor,
              fontWeight: FontWeight.w700,
              fontFamily: kFontArticulatCFNormal
            ),
          ),
        ],
      ),
    );
  }
}
