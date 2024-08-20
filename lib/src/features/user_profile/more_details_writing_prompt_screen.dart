import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/data/response/more_details_question_response.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/common_button.dart';
import '../../common/widgets/icon_button.dart';
import '../../list_items/interest_list_item_view.dart';
import '../../providers/app_provider.dart';
import '../../providers/data_providers.dart';
import '../../utils/constants.dart';
import '../../utils/dimens.dart';

class MoreDetailsWritingPromptScreen extends ConsumerStatefulWidget {
  final QuestionAnswerData questionAnswerData;
  const MoreDetailsWritingPromptScreen({super.key,required this.questionAnswerData});

  @override
  ConsumerState<MoreDetailsWritingPromptScreen> createState() => _MoreDetailsWritingPromptScreenState();
}

class _MoreDetailsWritingPromptScreenState extends ConsumerState<MoreDetailsWritingPromptScreen> {
  TextEditingController answerTextController = TextEditingController();


  @override
  void initState() {
    super.initState();
    answerTextController.text = widget.questionAnswerData.answerText ?? "";
  }

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
          child: InkWell(
            onTap: () async{
              var request = {
                "question_id" : widget.questionAnswerData.id,
                "answer_text": answerTextController.text
              };
              var response =
                  await ref.read(repositoryProvider).updateMoreDetailsAnswer(request, context);
              if (response.statusCode.toString().startsWith('2')) {
                ref.invalidate(moreDetailsQuestionListProvider);
                ref.invalidate(profileDataProvider);
                Navigator.of(context).pop();
              }
            },
              child: Icon(Icons.check,color: primaryColor,)),
        )],
      ),
      backgroundColor: whitePaleColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text(
                  widget.questionAnswerData.question ?? "",
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
                  child: TextFormField(
                    controller: answerTextController,
                    textAlign: TextAlign.left,
                    maxLines: 10,
                    decoration: InputDecoration(border: InputBorder.none,
                      hintStyle: GoogleFonts.roboto(
                        fontSize: kTextRegular3x,
                        color: greyColor,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: answerTextController.text.isEmpty ? 'Please enter...' : ''),
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
                    '',
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
      ),
    );
  }
}
