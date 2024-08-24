import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/coin_count.dart';
import 'package:phoosar/src/common/widgets/text_icon_button.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_more_likes_dialog.dart';
import 'package:phoosar/src/features/user_profile/edit_profile.dart';
import 'package:phoosar/src/features/user_setting/user_setting_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phoosar/src/utils/strings.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selfProfileData = ref.watch(selfProfileProvider);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: whitePaleColor,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MediaQuery.of(context).padding.top.vGap,
              Center(
                child: Image.asset(
                  'assets/images/ic_launcher.png',
                  width: 42,
                ),
              ),
              12.vGap,
              Divider(
                height: 1,
                color: greyColor,
              ),
              12.vGap,
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => GetMoreLikesDialog(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.kYourCoinsLabel,
                          style: GoogleFonts.roboto(
                            fontSize: smallLargeFontSize,
                            color: blackColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        12.hGap,
                        CoinCount(
                          coinCount: '200',
                          backgroundColor: greyColor,
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: greyColor,
                    )
                  ],
                ),
              ),
              12.vGap,
              Divider(
                height: 1,
                color: greyColor,
              ),
              12.vGap,
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      width: MediaQuery.of(context).size.width - 32,
                      height: MediaQuery.of(context).size.height * 0.5,
                      fit: BoxFit.cover, imageUrl: (selfProfileData!.data!.profileImages != null &&
                        selfProfileData.data!.profileImages!.isNotEmpty)
                        ? selfProfileData.data?.profileImages![0] ??
                        errorImageUrl
                        : errorImageUrl,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 32,
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: MediaQuery.of(context).size.width * 0.3,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              selfProfileData.data?.name ?? '',
                              style: GoogleFonts.roboto(
                                fontSize: largeFontSize,
                                color: whiteColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            12.hGap,
                            Text(
                              calculateAge(
                                  selfProfileData.data?.birthdate ?? ''),
                              style: GoogleFonts.roboto(
                                fontSize: mediumLargeFontSize,
                                color: whiteColor,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              12.vGap,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonTextIconButton(
                    text: AppLocalizations.of(context)!.kSettingUpperCaseLabel,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserSettingScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.settings,
                      size: 28,
                      color: greyColor,
                    ),
                  ),
                  12.hGap,
                  CommonTextIconButton(
                    text: AppLocalizations.of(context)!.kEditProfileLabel,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: greyColor,
                      size: 28,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String calculateAge(String birthdate) {
    if (birthdate.isEmpty) return '';
    DateTime birthDate = DateTime.parse(birthdate);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }
}
