import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/common_textfield.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class ProfileBuilder extends StatefulWidget {
  const ProfileBuilder({super.key});

  @override
  State<ProfileBuilder> createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
      ),
      height: MediaQuery.of(context).size.height * 0.67,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Profile Builder',
                style: GoogleFonts.roboto(
                  fontSize: mediumLargeFontSize,
                  color: blueColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              12.hGap,
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.heart_broken,
                      size: 15,
                      color: Colors.red,
                    ),
                    Text(
                      '+10',
                      style: GoogleFonts.roboto(
                        fontSize: smallFontSize,
                        color: blueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            "Answer the question below and increase your likelihood of finding a better match. A full profile gets 3x matches.",
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
              fontSize: smallFontSize,
              color: blackColor,
              fontWeight: FontWeight.w100,
            ),
          ),
          12.vGap,
          Text(
            "After work, you can find me ..",
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
              fontSize: mediumFontSize,
              color: blackColor,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          12.vGap,
          CommonTextFormField(
            controller: _controller,
            hintText: "Tap here to answer",
            maxLines: 8,
          ),
          12.vGap,
          Center(
            child: CommonButton(
              text: "Save",
              onTap: () {
                showSnackBarFun(context);
                showSuccessUpdated(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  showSnackBarFun(context) {
    SnackBar snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.heart_broken,
            size: 15,
            color: Colors.red,
          ),
          4.hGap,
          Text(
            'You received 10 💕 for updating your profile',
            style: GoogleFonts.roboto(
              fontSize: smallFontSize,
              color: whiteColor,
            ),
          ),
        ],
      ),
      backgroundColor: blackColor,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showSuccessUpdated(context) {
    SnackBar snackBar = SnackBar(
      content: Text(
        'Profile successfully updated!',
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          fontSize: mediumFontSize,
          color: whiteColor,
        ),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 1, right: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
