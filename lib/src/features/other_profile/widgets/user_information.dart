import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/info_row.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';
import '../../../localization/app_localizations.dart';

import '../../../common/widgets/icon_button.dart';
import '../../../data/response/profile_react_response.dart';
import '../../../providers/app_provider.dart';
import '../../../utils/utils.dart';
import '../../dashboard/match.dart';

class UserInformation extends ConsumerWidget {
  const UserInformation(
      {super.key, required this.findData, this.isShowAboutText,this.isShowRemoveButton,this.otherProfileId,this.isShowLikeButton = true});

  final ProfileData findData;
  final bool? isShowAboutText;
  final bool? isShowRemoveButton;
  final bool? isShowLikeButton;
  final int? otherProfileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.circle,
              color: findData.isOnline == 1 ? Colors.green : Colors.red,
              size: 10,
            ),
            4.hGap,
            Text(
              findData.isOnline == 1
                  ? AppLocalizations.of(context)!.kOnlineLabel
                  : AppLocalizations.of(context)!.kOfflineLabel,
              style: TextStyle(
                fontSize: smallFontSize,
                color: blackColor,
                fontFamily: kFontArticulatCFLight,
              ),
            ),
          ],
        ),
        4.hGap,
        Row(
          children: [
            Text(
              findData.name ?? '',
              style: TextStyle(
                fontSize: largeFontSize,
                color: blackColor,
                fontFamily: kFontArticulatCFBold,
              ),
            ),
            12.hGap,
            Visibility(
              visible: findData.showAge!.showAgeStatus! == true ? false : true,
              child: Text(
                Utils.calculateAge(findData.birthdate ?? ''),
                style: TextStyle(
                    fontSize: smallLargeFontSize,
                    color: blackColor,
                    fontFamily: kFontArticulatCFLight),
              ),
            ),
            Spacer(),
            Visibility(
              visible: isShowRemoveButton == true,
              child: CommonIconButton(
                padding: 0,
                onTap: () async {
                  await _handleRemove(ref, context,otherProfileId ?? 0);
                },
                backgroundColor: Colors.transparent,
                icon: Image.asset(
                  'assets/images/skip.png',
                  width: 50,
                ),
              ),
            ),
            Visibility(
              visible: isShowLikeButton == true,
              child: CommonIconButton(
                onTap: () async {
                  await _handleLike(ref, context);
                },
                padding: 8,
                backgroundColor: Colors.transparent,
                icon: Image.asset(
                  'assets/images/ok.png',
                  width: 50,
                ),
              ),
            ),
          ],
        ),
        8.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/location.png',
            width: 10,
            color: blackColor,
          ),
          isOtherProfile: true,
          text: findData.city ?? '' + ' km away',
          textColor: blackColor,
        ),
        6.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/work.png',
            width: 12,
            color: blackColor,
          ),
          isOtherProfile: true,
          text: findData.jobTitle ?? '',
          textColor: blackColor,
        ),
        6.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/address.png',
            width: 12,
            color: blackColor,
          ),
          isOtherProfile: true,
          text: 'Live in ${findData.city ?? ''}',
          textColor: blackColor,
        ),
        6.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/school.png',
            width: 12,
            color: blackColor,
          ),
          isOtherProfile: true,
          text: findData.school ?? '',
          textColor: blackColor,
        ),
        6.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/date.png',
            width: 12,
            color: blackColor,
          ),
          isOtherProfile: true,
          text: findData.birthdate ?? '',
          textColor: blackColor,
        ),
        6.vGap,
        UserInfoRow(
          icon: Image.asset(
            'assets/images/smoke.png',
            width: 12,
            color: blackColor,
          ),
          isOtherProfile: true,
          text: findData.smoke == "1" ? "Yes" : "No",
          textColor: blackColor,
        ),
        8.vGap,
        Visibility(
          visible: isShowAboutText ?? true,
          child: Divider(
            height: 1,
            color: greyColor,
          ),
        ),
        20.vGap,
        Visibility(
          visible: isShowAboutText ?? true,
          child: Text(
            findData.about ?? "",
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
              fontSize: smallFontSize,
              color: blackColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleLike(WidgetRef ref, BuildContext context) async {
    var response =
        await ref.read(repositoryProvider).saveProfileReact(
              jsonEncode({
                "reacted_user_id": findData.id.toString(),
                "reacted_type": "like"
              }),
              context,
            );
    var profileReactResponse = ProfileReactResponse.fromJson(
      jsonDecode(response.body),
    );

    if (profileReactResponse.data?.matchData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MatchScreen(
            matchProfileData: profileReactResponse.data?.matchData,
          ),
        ),
      );
    }
  }

  Future<void> _handleRemove(WidgetRef ref, BuildContext context,int id) async {
    var response =
    await ref.read(repositoryProvider).removeLiked(
      context,
      id
    );
    if (response.statusCode
        .toString()
        .startsWith('2')) {
      Navigator.pop(context);
      ref.invalidate(likedYouListProvider);
    }
  }
}
