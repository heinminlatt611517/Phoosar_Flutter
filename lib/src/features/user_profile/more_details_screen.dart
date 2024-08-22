import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/features/user_profile/more_details_writing_prompt_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';
import '../../utils/constants.dart';
import '../../utils/dimens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoreDetailsScreen extends ConsumerWidget {
  const MoreDetailsScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var questionData = ref.watch(moreDetailsQuestionListProvider(context));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whitePaleColor,
        title: Text(AppLocalizations.of(context)!.kMoreDetailsLabel,),
        centerTitle: true,
      ),
      backgroundColor: whitePaleColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          20.vGap,
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Use these writing prompt to make your\nprofile even better! Click on a prompt to',
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                fontSize: kTextRegular3x,
                color: blackColor,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          20.vGap,
            questionData.when(data: (data){
              debugPrint("Data======>>>>$data");
              return
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreDetailsWritingPromptScreen(questionAnswerData: data[index],),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index].question ?? "",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              8.vGap,
                              Text(
                                data[index].answerText ?? "",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                  fontSize: smallFontSize,
                                  color: blackColor,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              14.vGap
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },itemCount: data.length,);
            }, error: (error,stack){
              return Container();
            }, loading: (){
              return Center(child: SpinKitThreeBounce(color: Colors.pinkAccent,),);
            })

        ]),
      ),
    );
  }
}
