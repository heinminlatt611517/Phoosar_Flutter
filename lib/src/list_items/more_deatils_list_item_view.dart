import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../common/widgets/icon_button.dart';
import '../common/widgets/yes_no_dialog.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class MoreDetailsListItemView extends StatelessWidget {
  final String title;
  final String description;
  final String id;
  final Function(String id) onTapDelete;
  const MoreDetailsListItemView({super.key,required this.id,required this.title,required this.description,required this.onTapDelete});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontFamily: kFontGibsonBold,fontSize: kTextRegular18,color: primaryColor),
                ),
              ),
              CommonIconButton(
                onTap: () {
                   onTapDelete(id);
                },
                backgroundColor: Colors.transparent,
                borderColor: redColor,
                icon: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.asset(
                    'assets/images/delete_icon.png',
                    width: 12,
                    color: redColor,
                  ),
                ),
                padding: 4,
              ),
            ],
          ),
          8.vGap,
          Text(
            description,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: smallFontSize,
              color: blackColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
