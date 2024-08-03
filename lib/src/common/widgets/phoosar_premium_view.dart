import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../utils/dimens.dart';

///Phoosar premium view
Widget PhoosarPremiumView(BuildContext context, String label) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: kMarginMedium),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/phoosar_premium_img.png',
          width: MediaQuery.of(context).size.width / 2,
        ),
        10.vGap,
        Text(
          "Phoosar Premium",
          style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: kTextRegular22),
        ),
        10.vGap,
        Text(
          label,
          style: TextStyle(color: Colors.grey.withOpacity(0.4)),
        ),
      ],
    ),
  );
}
