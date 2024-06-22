import 'package:flutter/material.dart';
import 'package:phoosar/src/features/auth/help_us_screen.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/common_button.dart';
import '../../utils/dimens.dart';

class UploadProfileImageScreen extends StatefulWidget {
  const UploadProfileImageScreen({super.key});

  @override
  State<UploadProfileImageScreen> createState() =>
      _UploadProfileImageScreenState();
}

class _UploadProfileImageScreenState extends State<UploadProfileImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/ic_launcher.png',
          height: 60,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(kMarginLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                kUploadYourProfileImage,
                style: TextStyle(color: Colors.grey, fontSize: kTextRegular24),
              ),

              60.vGap,

              ///choose image view
              ChooseImageView(),

              60.vGap,

              ///continue button
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: CommonButton(
                  containerVPadding: 10,
                  text: kContinueLabel,
                  fontSize: 18,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpUsScreen(),
                      ),
                    );
                  },
                  bgColor: Colors.pinkAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///choose image container view
class ChooseImageView extends StatelessWidget {
  const ChooseImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///user image view
        Stack(
          children: [
            Container(
              height: 240,
              width: 240,
              decoration: BoxDecoration(color: whitePaleColor),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/upload_profile_img.png',
                height: 240,
                width: 240,
              ),
            )
          ],
        ),

        26.vGap,

        ///choose image button
        CommonButton(
          containerVPadding: 10,
          text: kChooseImageLabel,
          fontSize: 18,
          onTap: () {},
          bgColor: Colors.grey.withOpacity(0.5),
        ),
      ],
    );
  }
}
