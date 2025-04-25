import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/features/dashboard/widgets/unlock_dailog.dart';
import 'package:phoosar/src/features/payment/payment.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';

class CoinRow extends StatelessWidget {
  const CoinRow(
      {super.key,
      required this.likeHeartCount,
      required this.heartCount,
      required this.planType,
      required this.planTypeId,
      required this.amount});
  final String likeHeartCount;
  final String heartCount;
  final String amount;
  final String planType;
  final String planTypeId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///heart count icon container
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: blackColor,width: 1.5),
                  borderRadius: BorderRadius.circular(20),
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
                      heartCount,
                      style: GoogleFonts.roboto(
                        fontSize: smallFontSize,
                        color: blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///like heart count
          Row(
            children: [
              SizedBox(
                child: Text(
                  likeHeartCount,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.roboto(
                    fontSize: mediumFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                ' MMK',
                style: TextStyle(
                  fontSize: mediumFontSize,
                  fontWeight: FontWeight.normal,
                  color: blackColor
                ),
              ),
            ],
          ),

          ///buy now text
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                          planType: planType,
                          planTypeId: planTypeId,
                          amount: amount)));
            },
            child: Text(
              'BUY NOW',
              style: TextStyle(
                fontSize: kTextRegular,
                color: greenColor,
                fontFamily: kFontGibsonBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
