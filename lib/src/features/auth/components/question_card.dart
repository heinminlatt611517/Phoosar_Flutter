import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/question.dart';
import '../../../utils/constants.dart';
import '../controller/question_controller.dart';
import 'option.dart';


class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    // it means we have to pass this
    @required this.question,
  }) : super(key: key);

  final Question? question;

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            question?.question ?? '',
          ),
          SizedBox(height: kDefaultPadding / 2),
          ...List.generate(
            question?.options?.length ?? 0,
                (index) => Option(
              index: index,
              text: question?.options?[index],
              press: () => _controller.checkAns(question!, index),
            ),
          ),
        ],
      ),
    );
  }
}