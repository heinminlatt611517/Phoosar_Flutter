import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/common_textfield.dart';
import 'package:phoosar/src/common/widgets/error_dialog.dart';
import 'package:phoosar/src/data/response/profile_builder_response.dart';
import 'package:phoosar/src/data/response/profile_builder_save_response.dart';
import 'package:phoosar/src/data/response/self_profile_response.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class ProfileBuilder extends ConsumerStatefulWidget {
  const ProfileBuilder(
      {super.key,
      required this.profileBuilderData,
      required this.onSave,
      required this.onCancel});
  final ProfileBuilderData profileBuilderData;
  final Function() onSave;
  final Function() onCancel;

  @override
  ConsumerState<ProfileBuilder> createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends ConsumerState<ProfileBuilder> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
      ),
      height: MediaQuery.of(context).size.height * 0.67,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Profile Builder',
                style: GoogleFonts.roboto(
                  fontSize: mediumLargeFontSize,
                  color: blueColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              12.hGap,
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ic_love.png',
                      width: 15,
                      color: Colors.red,
                    ),
                    Text(
                      ' ++',
                      style: GoogleFonts.roboto(
                        fontSize: smallFontSize,
                        color: blueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.vGap,
          Text(
            "Answer the question below and increase your likelihood of finding a better match. A full profile gets 3x matches.",
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
              fontSize: mediumFontSize,
              color: blackColor,
              fontWeight: FontWeight.w100,
            ),
          ),
          20.vGap,
          Text(
            widget.profileBuilderData.question ?? '',
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
              fontSize: mediumFontSize,
              color: blackColor,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          12.vGap,
          CommonTextFormField(
            controller: _controller,
            hintText: "Tap here to answer",
            maxLines: 8,
          ),
          20.vGap,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonButton(
                text: "Cancel",
                containerVPadding: 12,
                containerHPadding: 20,
                onTap: () {
                  widget.onCancel();
                },
              ),
              12.hGap,
              CommonButton(
                text: "Save",
                containerVPadding: 12,
                containerHPadding: 20,
                onTap: () {
                  if (_controller.text.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                              title: "Empty Answer",
                              message: "Please enter your answer",
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ));
                  } else {
                    saveProfileBuilderQuestion();
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  saveProfileBuilderQuestion() async {
    var response =
        await ref.read(repositoryProvider).saveProfileBuiderQuestion({
      "question_id": widget.profileBuilderData.id.toString(),
      "answer_text": _controller.text.toString()
    }, context);
    if (response.statusCode == 200) {
      var profileBuilderSaveResponse =
          ProfileBuilderSaveResponse.fromJson(jsonDecode(response.body));

      final repository = ref.watch(repositoryProvider);
      repository.saveOnlineStatus(
        jsonEncode({"is_online": true}),
        context,
      );

      final profileesponse =
          await repository.getProfile(jsonEncode({}), context);
      var data = SelfProfileResponse.fromJson(jsonDecode(profileesponse.body));
      ref.read(selfProfileProvider.notifier).state = data;
      ref.read(locationProvider.notifier).state = data.data?.city ?? "";
      showSuccessUpdated(context);
      showSnackBarFun(
          context, profileBuilderSaveResponse.data?.questionBuilderPoint ?? 0);

      widget.onSave();
    }
  }

  showSnackBarFun(context, count) {
    SnackBar snackBar = SnackBar(
      content: Row(
        children: [
          Image.asset("assets/images/ic_love.png",
              width: 15, color: Colors.red),
          4.hGap,
          Text(
            'You received $count 💕 for updating your profile',
            style: GoogleFonts.roboto(
              fontSize: smallFontSize,
              color: whiteColor,
            ),
          ),
        ],
      ),
      backgroundColor: blackColor,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 120,
          left: 10,
          right: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showSuccessUpdated(context) {
    SnackBar snackBar = SnackBar(
      content: Text(
        'Profile successfully updated!',
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          fontSize: mediumFontSize,
          color: whiteColor,
        ),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 1, right: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
