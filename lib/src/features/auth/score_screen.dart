import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoosar/src/utils/fonts.dart';

import 'controller/question_controller.dart';

class ScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuestionController _qnController = Get.put(QuestionController());
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          Column(
            children: [
              Spacer(flex: 3),
              Text(
                "Score",
                style: TextStyle(color: Colors.white,fontSize: 24,fontFamily: kFontGibsonBold),
              ),
              Spacer(),
              Text(
                  "${_qnController.correctAns != null ? _qnController.correctAns! * 10 : 0}/${_qnController.questions.length * 10}",
                  style: TextStyle(color: Colors.white,fontSize: 24,fontFamily: kFontGibsonBold),
              ),
              Spacer(flex: 3),
            ],
          )
        ],
      ),
    );
  }
}