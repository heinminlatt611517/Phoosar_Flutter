import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../common/widgets/icon_button.dart';
import '../common/widgets/yes_no_dialog.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class MoreDetailsListItemView extends StatelessWidget {
  final String title;
  final String description;
  const MoreDetailsListItemView({super.key,required this.title,required this.description});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  fontSize: mediumFontSize,
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Spacer(),
              CommonIconButton(
                onTap: () {
                  showYesNoDialog(context: context, onPress: (){},title: 'Are you sure you want to delete?');
                },
                backgroundColor: primaryColor,
                icon: Icon(
                  Icons.delete,
                  color: whiteColor,
                  size: 18,
                ),
                padding: 4,
              ),
            ],
          ),
          8.vGap,
          Text(
            description,
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
              fontSize: smallFontSize,
              color: blackColor,
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }
}
