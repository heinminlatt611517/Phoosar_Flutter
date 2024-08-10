import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/data/response/more_details_question_response.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/common_button.dart';
import '../../common/widgets/icon_button.dart';
import '../../list_items/interest_list_item_view.dart';
import '../../utils/constants.dart';
import '../../utils/dimens.dart';

class MoreDetailsWritingPromptScreen extends StatelessWidget {
  final QuestionAnswerData questionAnswerData;
  const MoreDetailsWritingPromptScreen({super.key,required this.questionAnswerData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whitePaleColor,
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(Icons.clear),
          ),
        ),
        actions: [Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(Icons.check,color: primaryColor,),
        )],
      ),
      backgroundColor: whitePaleColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Text(
                'Beach or mountains...',
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  fontSize: kTextRegular3x,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text(
                  'Force Dark analyzes each view of your light-themed app and applies a dark theme automatically before it is drawn to the screen. You can use a mix of Force Dark and native implementation to cut down on the time needed to implement dark theme.',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: kTextRegular3x,
                    color: greyColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              100.vGap,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text(
                  'Beach',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: kTextRegular3x,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            20.vGap,

          ]),
        ),
      ),
    );
  }
}
