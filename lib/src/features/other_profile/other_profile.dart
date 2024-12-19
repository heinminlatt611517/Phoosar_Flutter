import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/features/dashboard/widgets/report_success_dailog.dart';
import 'package:phoosar/src/features/other_profile/widgets/more_information.dart';
import 'package:phoosar/src/features/other_profile/widgets/profile_slider.dart';
import 'package:phoosar/src/features/other_profile/widgets/user_hobbies.dart';
import 'package:phoosar/src/features/other_profile/widgets/user_information.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../providers/app_provider.dart';
import '../../utils/dimens.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
    required this.findData,
  });
  final ProfileData findData;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitePaleColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                OtherUserProfileSlider(
                  profileImages: widget.findData.profileImages ?? [],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,top: 40),
                  child: InkWell(
                      onTap: (){ Navigator.of(context).pop();},
                      child: Icon(Icons.arrow_back,color: Colors.grey.withOpacity(0.5),size: 40,)),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInformation(findData: widget.findData),
                  20.vGap,
                  // Divider(
                  //   height: 0,
                  //   color: greyColor,
                  // ),
                  // 20.vGap,
                  UserHobbies(findData: widget.findData,),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.findData.moreDetails?.length,
                      itemBuilder: (context,index){
                    return MoreInformation(title: widget.findData.moreDetails?[index].question ?? "", description: widget.findData.moreDetails?[index].answerText ?? "");
                  }),
                  20.vGap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.report,
                        color: greyColor,
                      ),
                      12.hGap,
                      InkWell(
                        onTap: () async{

                         showDialog(context: context, builder: (context) => ReportDialog(findData: widget.findData,));
                        },
                        child: Text(
                          'Report ${widget.findData.name}',
                          style: GoogleFonts.roboto(
                            fontSize: smallLargeFontSize,
                            color: greyColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  20.vGap,
                  Divider(
                    height: 1,
                    color: greyColor,
                  ),
                  20.vGap,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///report dialog view
class ReportDialog extends ConsumerStatefulWidget {
  ProfileData findData;
  ReportDialog({super.key,required this.findData});

  @override
  ConsumerState<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends ConsumerState<ReportDialog> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:const EdgeInsets.all(10),
      surfaceTintColor: Colors.white,
      child: Container(
        padding:const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Container(),
              const Spacer(),
              InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.clear,color: Colors.grey,))
            ],),
            20.vGap,
            const Text('Confirmation',style: TextStyle(fontSize: kTextRegular3x,color: Colors.black,fontWeight: FontWeight.w600),),
            4.vGap,
            const Text('Are you sure you want to report?',style: TextStyle(fontSize: kTextRegular,color: Colors.black,fontWeight: FontWeight.normal),),

            20.vGap,
            Visibility(
                visible: isLoading == true,
                child: SpinKitThreeBounce(color: primaryColor,)),
            Visibility(
              visible: isLoading == false,
              child: Row(children: [
                Expanded(child: CommonButton(
                    bgColor: Colors.red,
                    onTap: () {
                      Navigator.of(context).pop();
                    }, text: 'Cancel',)),
                20.hGap,
                Expanded(child: CommonButton(
                  bgColor: Colors.green,
                  onTap: () async{
                    setState(() {
                      isLoading = true;
                    });
                    var response = await ref.watch(repositoryProvider).saveReport(
                        jsonEncode({"report_user_id" : widget.findData.id.toString(),}), context);

                    if (response.statusCode.toString().startsWith("2")) {
                      Navigator.pop(context);
                      setState(() {
                        isLoading = false;
                      });
                      showDialog(
                          context: context,
                          builder: (context) => ReportSuccessDailog());
                    }
                  }, text: 'Ok',)),
              ],),
            )
          ],),
      ),
    );
  }
}

