import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showSnackBarFun(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitePaleColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ic_launcher.png',
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            20.vGap,
            Center(
              child: Text(
                'It\'s a match',
                style: GoogleFonts.roboto(
                  fontSize: 23,
                  color: blueColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              "Seem like you two like each other!",
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: blackColor,
                fontWeight: FontWeight.w300,
              ),
            ),
            12.vGap,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/sample_profile.png",
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.4,
                    fit: BoxFit.cover,
                  ),
                ),
                8.hGap,
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/sample_profile2.jpeg",
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.4,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            30.vGap,
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'MESSAGE',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            12.vGap,
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: whitePaleColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: greyColor, width: 1),
                  ),
                  child: Text(
                    'CONTINUE PLAYING',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: blackColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
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
            'You received 5 💕 for getting a match',
            style: GoogleFonts.roboto(
              fontSize: 11,
              color: whiteColor,
            ),
          ),
        ],
      ),
      backgroundColor: blackColor,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 40, left: 1, right: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
