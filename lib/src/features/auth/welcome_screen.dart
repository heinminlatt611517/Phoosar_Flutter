import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:phoosar/src/features/auth/quiz_screen.dart';
import 'package:phoosar/src/utils/fonts.dart';
import '../../utils/constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: SvgPicture.asset("assets/icons/bg.svg",width: double.infinity,)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(flex: 2), //2/6
                Text(
                  "Let's Play Quiz,",style: TextStyle(fontSize: 18,color: Colors.white,fontFamily: kFontGibsonBold),),
                Text("Enter your informations below",style: TextStyle(fontSize: 16,color: Colors.white),),
                Spacer(), // 1/6
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF1C2341),
                    hintText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                Spacer(), // 1/6
                InkWell(
                  onTap: () => Get.to(QuizScreen()),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
                    decoration: BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Text(
                      "Lets Start Quiz",
                    ),
                  ),
                ),
                Spacer(flex: 2), // it will take 2/6 spaces
              ],
            ),
          ),
        ],
      ),
    );
  }
}