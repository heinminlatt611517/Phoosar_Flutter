import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/app_provider.dart';
import '../../utils/dimens.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, required this.findData, this.isShowRemoveButton,this.otherProfileId,this.isShowLikeButton});

  final ProfileData findData;
  final bool? isShowRemoveButton;
  final bool? isShowLikeButton;
  final int? otherProfileId;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
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
                  padding: const EdgeInsets.only(left: 20, top: 40),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      'assets/images/backward.png',
                      height: 20,
                      width: 20,
                      color: Color(0xFFDE2966),
                    ),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.vGap,
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kMarginMedium2),
                  child: UserInformation(
                    findData: widget.findData,
                    isShowAboutText: false,
                    isShowRemoveButton: widget.isShowRemoveButton,
                    otherProfileId: widget.otherProfileId,
                    isShowLikeButton: widget.isShowLikeButton,
                  ),
                ),

                Divider(
                  height: 1,
                  color: blackColor,
                ),

                Container(
                  color: whitePaleColor,
                  width: double.infinity,
                  padding: const EdgeInsets.all(kMarginMedium2),
                  child: Text(
                    widget.findData.about ?? "",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: mediumFontSize,
                      color: blackColor,
                      fontFamily: kFontArticulatCFLight,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: blackColor,
                ),

                ///hobbies
                Container(
                    width: double.infinity,
                    color: whitePaleColor,
                    padding: EdgeInsets.only(
                        left: kMarginMedium2,
                        right: kMarginMedium2,
                        top: kMarginMedium2),
                    child: UserHobbies(
                      findData: widget.findData,
                    )),

                ///more details
                Container(
                  color: whitePaleColor,
                  padding: EdgeInsets.symmetric(horizontal: kMarginMedium2),
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.findData.moreDetails?.length,
                      itemBuilder: (context, index) {
                        return MoreInformation(
                            title: widget.findData.moreDetails?[index].question
                                    ?.toUpperCase() ??
                                "",
                            description: widget
                                    .findData.moreDetails?[index].answerText ??
                                "");
                      }),
                ),
                20.vGap,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove_circle_outline,
                      color: redColor.withOpacity(0.3),
                    ),
                    12.hGap,
                    InkWell(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) => ReportDialog(
                                  findData: widget.findData,
                                ));
                      },
                      child: Text(
                        'Report ${widget.findData.name}'.toUpperCase(),
                        style: TextStyle(
                            fontSize: smallLargeFontSize,
                            color: redColor,
                            fontWeight: FontWeight.w700,
                            fontFamily: kFontArticulatCFBold),
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
          ],
        ),
      ),
    );
  }
}

///report dialog view
class ReportDialog extends ConsumerStatefulWidget {
  ProfileData findData;

  ReportDialog({super.key, required this.findData});

  @override
  ConsumerState<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends ConsumerState<ReportDialog> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      surfaceTintColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(),
                const Spacer(),
                InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ))
              ],
            ),
            20.vGap,
            Text(
              AppLocalizations.of(context)!.kConfirmation,
              style: TextStyle(
                  fontSize: kTextRegular3x,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            4.vGap,
            Text(
              AppLocalizations.of(context)!.kSureWantToReport,
              style: TextStyle(
                  fontSize: kTextRegular,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
            20.vGap,
            Visibility(
                visible: isLoading == true,
                child: SpinKitThreeBounce(
                  color: primaryColor,
                )),
            Visibility(
              visible: isLoading == false,
              child: Row(
                children: [
                  Expanded(
                      child: CommonButton(
                    bgColor: Colors.red,
                    fontSize: 14,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    text: AppLocalizations.of(context)!.kCancel,
                  )),
                  10.hGap,
                  Expanded(
                      child: CommonButton(
                    bgColor: Colors.green,
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      var response =
                          await ref.watch(repositoryProvider).saveReport(
                              jsonEncode({
                                "report_user_id": widget.findData.id.toString(),
                              }),
                              context);

                      if (response.statusCode.toString().startsWith("2")) {
                        Navigator.pop(context);
                        setState(() {
                          isLoading = false;
                        });
                        showDialog(
                            context: context,
                            builder: (context) => ReportSuccessDailog());
                      }
                    },
                    text: AppLocalizations.of(context)!.kOk,
                  )),
                ],
              ),
            ),
            10.vGap
          ],
        ),
      ),
    );
  }
}
