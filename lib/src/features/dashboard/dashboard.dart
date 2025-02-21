import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phoosar/src/common/empty_find_dialog.dart';
import 'package:phoosar/src/common/widgets/icon_button.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/data/response/profile_builder_response.dart';
import 'package:phoosar/src/data/response/profile_react_response.dart';
import 'package:phoosar/src/data/response/self_profile_response.dart';
import 'package:phoosar/src/features/dashboard/match.dart';
import 'package:phoosar/src/features/dashboard/widgets/find_stronger_matches_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_more_likes_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_more_rewinds_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/header.dart';
import 'package:phoosar/src/features/dashboard/widgets/info_card.dart';
import 'package:phoosar/src/features/dashboard/widgets/profile_builder.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/widgets/force_update_dialog.dart';
import '../../data/response/config_response.dart';
import '../auth/login.dart';
import '../other_profile/other_profile.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool isProfileBuilder = false;
  int selectedIndex = 0;
  bool emptyShown = false;
  ProfileBuilderData? profileBuilderData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchConfigData();
      await _checkOnlineStatus();
      await _fetchProfile();
      await setFcmToken();
    });
  }

  ///check online status
  Future<void> _checkOnlineStatus() async {
    final repository = ref.watch(repositoryProvider);
    final response = await repository.saveOnlineStatus(
      jsonEncode({"is_online": true}),
      context,
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    debugPrint("Value>>>>>>${data['is_active']}");
    if (data['is_active'] == 0) {
      await ref.read(sharedPrefProvider).clear();
      ref.invalidate(dashboardProvider);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  ///set fcm token
  Future<void> setFcmToken() async {
    var sharedPrefs = ref.watch(sharedPrefProvider);
    var fcmToken = sharedPrefs.getString("fcmToken");
    final repository = ref.watch(repositoryProvider);
    final response = await repository.setFcmToken(
      jsonEncode({"fcm_token": fcmToken}),
      context,
    );
    debugPrint("FCMTOKEN>>>>>$fcmToken");
    debugPrint("SetFCMResponse>>>>>$response");
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

  ///fetch config data
  Future<void> _fetchConfigData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final response = await ref.read(repositoryProvider).getConfig(
          context,
        );
    var data = ConfigResponse.fromJson(jsonDecode(response.body)).data;
    ref.read(percentageProvider.notifier).state = data?.percentage ?? 0;

    if (compareVersionStrings(packageInfo.version, data?.releaseVersion ?? "") <
        0) {
      forceUpdateDialog(context: context, ref: ref);
    }
  }

  ///compare version
  int compareVersionStrings(String currentVersion, String releaseVersion) {
    List<int> currentVersionParts =
        currentVersion.split('.').map((e) => int.parse(e)).toList();
    List<int> releaseVersionParts =
        releaseVersion.split('.').map((e) => int.parse(e)).toList();
    for (int i = 0; i < currentVersionParts.length; i++) {
      if (i >= releaseVersionParts.length) {
        return 1;
      }
      if (currentVersionParts[i] < releaseVersionParts[i]) {
        return -1;
      } else if (currentVersionParts[i] > releaseVersionParts[i]) {
        return 1;
      }
    }
    return currentVersionParts.length == releaseVersionParts.length ? 0 : -1;
  }

  @override
  Widget build(BuildContext context) {
    final findListState = ref.watch(findListNotifierProvider(context));

    ///body content
    return Container(
      height: double.infinity,
      color: whitePaleColor,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MediaQuery.of(context).padding.top.vGap,
              DashboardHeader(),
              findListState.when(
                data: (profiles) {
                  if (profiles == null || profiles.isEmpty) {
                    return Container(
                      height: context.heightPx * 0.8,
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.kLastProfile),
                      ),
                    );
                  }
                  if (selectedIndex >= profiles.length) {
                    selectedIndex = profiles.length - 1;
                  }
                  return Column(
                    children: [
                      Visibility(
                        visible: !isProfileBuilder,
                        child: InfoCard(findData: profiles[selectedIndex]),
                      ),
                      Visibility(
                        visible: isProfileBuilder,
                        child: ProfileBuilder(
                          profileBuilderData:
                              profileBuilderData ?? ProfileBuilderData(),
                          onSave: () {
                            setState(() {
                              profileBuilderData = null;
                              isProfileBuilder = false;
                            });
                          },
                          onCancel: () {
                            setState(() {
                              profileBuilderData = null;
                              isProfileBuilder = false;
                            });
                          },
                        ),
                      ),
                      20.vGap,
                      Visibility(
                        visible: !isProfileBuilder,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ///rewind
                            CommonIconButton(
                              onTap: () async {
                                await _handleRewind(profiles);
                              },
                              backgroundColor: Colors.transparent,
                              icon: Image.asset(
                                'assets/images/rewind.png',
                                width: 50,
                              ),
                            ),

                            ///skip
                            CommonIconButton(
                              onTap: () async {
                                await _handleSkip(profiles);
                              },
                              backgroundColor: Colors.transparent,
                              icon: Image.asset(
                                'assets/images/skip.png',
                                width: 67,
                              ),
                            ),

                            ///ok
                            CommonIconButton(
                              onTap: () async {
                                await _handleLike(profiles);
                              },
                              backgroundColor: Colors.transparent,
                              icon: Image.asset(
                                'assets/images/ok.png',
                                width: 67,
                              ),
                            ),

                            ///info
                            CommonIconButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      findData: profiles[selectedIndex],
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: Colors.transparent,
                              icon: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  'assets/images/info.png',
                                  width: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                loading: () => Container(
                  height: context.heightPx * 0.6,
                  child: Center(
                    child: SpinKitThreeBounce(color: primaryColor),
                  ),
                ),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///rewind
  Future<void> _handleRewind(List<ProfileData> profiles) async {
    var response = await ref.read(repositoryProvider).saveProfileReact(
          jsonEncode({
            "reacted_user_id": profiles[selectedIndex].id.toString(),
            "reacted_type": "rewind"
          }),
          context,
        );

    var profileReactResponse = ProfileReactResponse.fromJson(
      jsonDecode(response.body),
    );

    if (profileReactResponse.data?.buyRewind ?? false) {
      showDialog(
        context: context,
        builder: (context) => GetMoreRewindsDialog(),
      );
    } else {
      if (profileReactResponse.data?.matchData != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchScreen(
              matchProfileData: profileReactResponse.data?.matchData,
            ),
          ),
        );
      } else {
        _decreaseIndexOrShowDialog(profiles);
      }
    }

    var sharedPrefs = ref.watch(sharedPrefProvider);
    var oldSwipeCount = sharedPrefs.getInt("swipeCount");
    var newSwipeCount = (oldSwipeCount ?? 0) + 1;

    if (selectedIndex != profiles.length) {
      if (newSwipeCount == 5) {
        sharedPrefs.setInt("swipeCount", 0);
        getProfileBuilderQuestion();
      } else {
        sharedPrefs.setInt("swipeCount", newSwipeCount);
      }
    } else {
      sharedPrefs.setInt("swipeCount", newSwipeCount);
    }
    ref.invalidate(swipeCountProvider);
  }

  ///skip
  Future<void> _handleSkip(List<ProfileData> profiles) async {
    await ref.read(repositoryProvider).saveProfileReact(
          jsonEncode({
            "reacted_user_id": profiles[selectedIndex].id.toString(),
            "reacted_type": "skip"
          }),
          context,
        );
    _increaseSwipeCount(profiles.length);
  }

  ///like
  Future<void> _handleLike(List<ProfileData> profiles) async {
    var response = await ref.read(repositoryProvider).saveProfileReact(
          jsonEncode({
            "reacted_user_id": profiles[selectedIndex].id.toString(),
            "reacted_type": "like"
          }),
          context,
        );

    var profileReactResponse = ProfileReactResponse.fromJson(
      jsonDecode(response.body),
    );

    if (profileReactResponse.data?.buyLike ?? false) {
      showDialog(
        context: context,
        builder: (context) => GetMoreLikesDialog(),
      );
    } else {
     // _increaseSwipeCountWhileOnPressOk(profiles.length);
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
      else {
        _increaseSwipeCountWhileOnPressOk(profiles.length);
      }
    }
  }

  ///increase swipe count
  void _increaseSwipeCount(int total) {
    var sharedPrefs = ref.watch(sharedPrefProvider);
    if (total > selectedIndex) {
      setState(() {
        selectedIndex++;
      });
      if (selectedIndex == total) {
        showDialog(
          context: context,
          builder: (context) => EmptyFindDialog(
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
              ref.invalidate(findListNotifierProvider);
              ref.invalidate(swipeCountProvider);
              sharedPrefs.setInt("swipeCount", 0);
            },
          ),
        );
      }
    } else {
      log('Last Index');
      ref.invalidate(swipeCountProvider);
      ref.invalidate(findListNotifierProvider);
    }
    var oldSwipeCount = sharedPrefs.getInt("swipeCount");
    var newSwipeCount = (oldSwipeCount ?? 0) + 1;
    log("newSwipeCount $newSwipeCount");

    if (selectedIndex != total) {
      if (newSwipeCount == 5) {
        sharedPrefs.setInt("swipeCount", 0);
        final percentage = ref.watch(percentageProvider);
        if (int.parse(percentage.toString()) < 100) {
          showDialog(
            context: context,
            builder: (context) => FindStrongerMatchesDialog(),
          );
        }
        else {
          //getProfileBuilderQuestion();
        }
      } else {
        sharedPrefs.setInt("swipeCount", newSwipeCount);
      }
    } else {
      sharedPrefs.setInt("swipeCount", newSwipeCount);
    }
    ref.invalidate(swipeCountProvider);
  }

  ///handle swipe count for while press ok
  void _increaseSwipeCountWhileOnPressOk(int total) {
    var sharedPrefs = ref.watch(sharedPrefProvider);
    if (total > selectedIndex) {
      setState(() {
        selectedIndex++;
      });
      if (selectedIndex == total) {
        showDialog(
          context: context,
          builder: (context) => EmptyFindDialog(
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
              ref.invalidate(findListNotifierProvider);
              ref.invalidate(swipeCountProvider);
              sharedPrefs.setInt("swipeCount", 0);
            },
          ),
        );
      }
    } else {
      log('Last Index');
      ref.invalidate(findListNotifierProvider);
      ref.invalidate(swipeCountProvider);
    }

    var oldSwipeCount = sharedPrefs.getInt("swipeCount");
    var newSwipeCount = (oldSwipeCount ?? 0) + 1;

    log("newSwipeCount $newSwipeCount");

    if (selectedIndex != total) {
      if (newSwipeCount == 5) {
        sharedPrefs.setInt("swipeCount", 0);
        getProfileBuilderQuestion();
      } else {
        sharedPrefs.setInt("swipeCount", newSwipeCount);
      }
    } else {
      sharedPrefs.setInt("swipeCount", newSwipeCount);
    }
    ref.invalidate(swipeCountProvider);
  }

  ///get profile builder question
  Future<void> getProfileBuilderQuestion() async {
    var response = await ref.read(repositoryProvider).getProfileBuiderQuestion(
          jsonEncode({}),
          context,
        );
    var profileBuilderQuestionResponse =
        ProfileBuilderResponse.fromJson(jsonDecode(response.body));
    setState(() {
      profileBuilderData = profileBuilderQuestionResponse.data;
      isProfileBuilder = true;
    });
  }

  ///decrease index or show dialog
  void _decreaseIndexOrShowDialog(List<ProfileData> profiles) {
    var sharedPrefs = ref.watch(sharedPrefProvider);
    if (selectedIndex > 0) {
      setState(() {
        selectedIndex--;
      });
      if (selectedIndex == 0) {
        showDialog(
          context: context,
          builder: (context) => EmptyFindDialog(
            onTap: () {
              ref.invalidate(findListNotifierProvider);
              ref.invalidate(swipeCountProvider);
              sharedPrefs.setInt("swipeCount", 0);
            },
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => EmptyFindDialog(
          onTap: () {
            ref.invalidate(findListNotifierProvider);
            ref.invalidate(swipeCountProvider);
            sharedPrefs.setInt("swipeCount", 0);
          },
        ),
      );
    }
  }
}
