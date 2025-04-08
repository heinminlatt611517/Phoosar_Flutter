import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/coin_count.dart';
import 'package:phoosar/src/common/widgets/text_icon_button.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_more_coins_dialog.dart';
import 'package:phoosar/src/features/user_profile/edit_profile.dart';
import 'package:phoosar/src/features/user_setting/phoosar_premium.dart';
import 'package:phoosar/src/features/user_setting/user_setting_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/extensions.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:phoosar/src/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart' hide CarouselController;
import 'package:shimmer/shimmer.dart';
import 'package:sized_context/sized_context.dart';

import '../../data/response/self_profile_response.dart';
import '../../providers/app_provider.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({
    super.key,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchProfile();
    });
  }

  ///fetch profile
  Future<void> _fetchProfile() async {
    final response = await ref.read(repositoryProvider).getProfile(
          jsonEncode({}),
          context,
        );
    var data = SelfProfileResponse.fromJson(jsonDecode(response.body));
    ref.read(selfProfileProvider.notifier).state = data;
    ref.read(locationProvider.notifier).state = data.data?.city ?? "";
  }

  @override
  Widget build(BuildContext context) {
    var selfProfileData = ref.watch(selfProfileProvider);
    var showBuyCoinData = ref.watch(showBuyCoinProvider);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: whitePaleColor,
      child: selfProfileData == null
          ? Container(
              height: context.heightPx * 0.5,
              child: Center(
                  child: SpinKitThreeBounce(
                color: primaryColor,
              )))
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    MediaQuery.of(context).padding.top.vGap,
                    8.vGap,
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Image.asset(
                          (selfProfileData.data?.isPremium ?? false)
                              ? 'assets/images/ic_premium_launcher.png'
                              : 'assets/images/phoosar_img.png',
                          width: (selfProfileData.data?.isPremium ?? false)
                              ? 60
                              : 120,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    12.vGap,
                    Divider(
                      height: 2.5,
                      color: Colors.black,
                    ),

                    ///normal view
                    Visibility(
                      visible: selfProfileData.data?.isPremium == true
                          ? false
                          : true,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => GetMoreCoinsDialog());
                        },
                        child: Container(
                          color: Color(0xFFF7F8FC),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Visibility(
                              visible: showBuyCoinData.toString() == '1',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      14.hGap,
                                      Text(
                                        '${AppLocalizations.of(context)!
                                            .kYourCoinsLabel}:',
                                        style : GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: blackColor,
                                        ),
                                      ),
                                      12.hGap,
                                      CoinCount(
                                        coinCount: selfProfileData != null
                                            ? (selfProfileData.data?.pointTotal
                                                    .toString() ??
                                                "0")
                                            : "0",
                                        backgroundColor: greyColor.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 14),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///premium view
                    Visibility(
                        visible: selfProfileData?.data?.isPremium == true
                            ? true
                            : false,
                        child: Container(
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PhoosarPremiumScreen(),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/images/phoosar_premium_img.png',
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(
                                        selfProfileData?.data?.isPremium ==
                                                false
                                            ? " "
                                            : DateTime.now().daysRemainingUntil(
                                                DateTime.parse(selfProfileData
                                                        ?.data?.membershipExpire
                                                        .toString() ??
                                                    DateTime.now().toString())),
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                color: Colors.grey.withOpacity(0.5),
                                width: 1,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!
                                          .kYourCoinsLabel}:',
                                      style: TextStyle(
                                          color: blackColor,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: kFontArticulatCFNormal,
                                          fontSize: 18
                                      ),
                                    ),
                                    12.hGap,
                                    IntrinsicWidth(
                                      child: CoinCount(
                                        coinCount: selfProfileData != null
                                            ? (selfProfileData.data?.pointTotal
                                                    .toString() ??
                                                "0")
                                            : "0",
                                        backgroundColor: greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),

                    Divider(
                      height: 2.5,
                      color: Colors.black,
                    ),
                    18.vGap,

                    ///profile images
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            (selfProfileData.data?.profileImages?.isNotEmpty ??
                                    false)
                                ? carousel_slider.CarouselSlider(
                                    options: carousel_slider.CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentIndex = index;
                                        });
                                      },
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 1,
                                      height: MediaQuery.of(context).size.height *
                                          0.44,
                                    ),
                                    items: selfProfileData.data?.profileImages
                                        ?.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return CachedNetworkImage(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            fit: BoxFit.cover,
                                            imageUrl: i,
                                            errorWidget: (context, url, error) {
                                              return Image.network(
                                                errorImageUrl,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    32,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            placeholder: (context, url) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor: Colors.grey[100]!,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      32,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.5,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }).toList(),
                                  )
                                : CachedNetworkImage(
                                    width: MediaQuery.of(context).size.width - 32,
                                    height:
                                        MediaQuery.of(context).size.height * 0.5,
                                    fit: BoxFit.cover,
                                    imageUrl: errorImageUrl,
                                    placeholder: (context, url) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width -
                                                  32,
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.5,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
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
                                    Visibility(
                                      visible: selfProfileData
                                              .data?.showAge?.showAgeStatus !=
                                          true,
                                      child: Text(
                                        Utils.calculateAge(
                                            selfProfileData.data?.birthdate ??
                                                ''),
                                        style: GoogleFonts.roboto(
                                          fontSize: mediumLargeFontSize,
                                          color: whiteColor,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 6,
                              child: DotsIndicator(
                                dotsCount: (selfProfileData
                                            .data?.profileImages?.isNotEmpty ??
                                        false)
                                    ? (selfProfileData
                                                .data?.profileImages?.length ??
                                            0)
                                        .clamp(1, double.infinity)
                                        .toInt()
                                    : 1, // Ensure dotsCount is at least 1
                                position: _currentIndex,
                                decorator: DotsDecorator(
                                  activeColor: blackColor,
                                  colors: List.filled(
                                    selfProfileData
                                            .data?.profileImages?.length ??
                                        0,
                                    Colors.white,
                                  ),
                                  size: const Size.square(7),
                                  activeSize: const Size(8, 8),
                                  activeShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side:
                                        BorderSide(color: Colors.white, width: 2),
                                  ),
                                  spacing: const EdgeInsets.all(4.0),
                                ),
                                axis: Axis.vertical,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    12.vGap,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonTextIconButton(
                          text: AppLocalizations.of(context)!
                              .kSettingUpperCaseLabel,
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
                            color: Colors.black,
                          ),
                        ),
                        20.hGap,
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
                            color:Colors.black,
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
}
