import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoosar/src/common/empty_find_dialog.dart';
import 'package:phoosar/src/common/widgets/icon_button.dart';
import 'package:phoosar/src/data/response/profile_builder_response.dart';
import 'package:phoosar/src/data/response/profile_react_response.dart';
import 'package:phoosar/src/data/response/self_profile_response.dart';
import 'package:phoosar/src/features/dashboard/match.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_more_likes_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_more_rewinds_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_premium_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/header.dart';
import 'package:phoosar/src/features/dashboard/widgets/info_card.dart';
import 'package:phoosar/src/features/dashboard/widgets/profile_builder.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../auth/login.dart';
import '../other_profile/other_profile.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({
    super.key,
  });

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
      final repository = ref.watch(repositoryProvider);
      repository.saveOnlineStatus(
        jsonEncode({"is_online": true}),
        context,
      ).then((value) async{
        Map<String, dynamic> data = jsonDecode(value.body);
        debugPrint("Value>>>>>>${data['is_active']}");
        if(data['is_active'] == 0){
          await ref.read(sharedPrefProvider).clear();
          ref.invalidate(dashboardProvider);
          /// Navigate to the login screen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
          );
        }
      });

      final response = await repository.getProfile(jsonEncode({}), context);
      var data = SelfProfileResponse.fromJson(jsonDecode(response.body));
      ref.read(selfProfileProvider.notifier).state = data;
      ref.read(locationProvider.notifier).state = data.data?.city ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final findListState = ref.watch(findListNotifierProvider(context));
    // var lastFindIds = ref.watch(lastFindIdsProvider);
    // log('lastFindIds -  $lastFindIds');

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
                            child: Text(
                                AppLocalizations.of(context)!.kLastProfile)));
                  }
                  // Ensure selectedIndex is within bounds
                  if (selectedIndex >= profiles.length) {
                    selectedIndex = profiles.length - 1;
                  }
                  return Column(
                    children: [
                      Visibility(
                          visible: !isProfileBuilder,
                          child: InfoCard(findData: profiles[selectedIndex])),
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
                          )),
                      20.vGap,
                      Visibility(
                        visible: !isProfileBuilder,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CommonIconButton(
                              onTap: () async {
                                // var latestLastFindIds = lastFindIds.last;

                                var response = await ref
                                    .read(repositoryProvider)
                                    .saveProfileReact(
                                      jsonEncode({
                                        "reacted_user_id":
                                            profiles[selectedIndex]
                                                .id
                                                .toString(),
                                        "reacted_type": "rewind"
                                      }),
                                      context,
                                    );

                                var profileReactResponse =
                                    ProfileReactResponse.fromJson(
                                        jsonDecode(response.body));

                                if (profileReactResponse.data?.buyRewind ??
                                    false) {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        GetMoreRewindsDialog(),
                                  );
                                } else {
                                  if (profileReactResponse.data?.matchData !=
                                      null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MatchScreen(
                                          matchProfileData: profileReactResponse
                                              .data?.matchData,
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (selectedIndex > 0) {
                                      setState(() {
                                        selectedIndex--;
                                      });
                                      if (selectedIndex == 0) {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                EmptyFindDialog(
                                                  onTap: () {
                                                    ref.invalidate(
                                                        findListNotifierProvider);
                                                  },
                                                ));
                                      }
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) => EmptyFindDialog(
                                                onTap: () {
                                                  ref.invalidate(
                                                      findListNotifierProvider);
                                                },
                                              ));
                                    }
                                    var sharedPrefs =
                                        ref.watch(sharedPrefProvider);
                                    var oldSwipeCount =
                                        sharedPrefs.getInt("swipeCount");
                                    var newSwipeCount =
                                        (oldSwipeCount ?? 0) + 1;

                                    log("newSwipeCount $newSwipeCount");

                                    if (newSwipeCount == 5) {
                                      sharedPrefs.setInt("swipeCount", 0);
                                      getProfileBuilderQuestion();
                                    } else {
                                      sharedPrefs.setInt(
                                          "swipeCount", newSwipeCount);
                                    }
                                    ref.invalidate(swipeCountProvider);
                                  }
                                }
                              },
                              backgroundColor: Colors.grey.withOpacity(0.1),
                              icon: SvgPicture.asset(
                                'assets/svgs/ic_backward.svg',
                                width: 18,
                                color: Colors.grey,
                              ),
                            ),
                            CommonIconButton(
                              onTap: () {
                                // var sharedPrefs =
                                //     ref.watch(sharedPrefProvider);
                                // var lastFindIds = sharedPrefs
                                //         .getStringList("lastFindIds") ??
                                //     [];
                                // if (lastFindIds.contains(
                                //     profiles[selectedIndex]
                                //         .id
                                //         .toString())) {
                                //   lastFindIds.add(profiles[selectedIndex]
                                //       .id
                                //       .toString());
                                //   sharedPrefs.setStringList(
                                //       "lastFindIds", lastFindIds);
                                //   ref.invalidate(lastFindIdsProvider);
                                // }

                                ref.read(repositoryProvider).saveProfileReact(
                                      jsonEncode({
                                        "reacted_user_id":
                                            profiles[selectedIndex]
                                                .id
                                                .toString(),
                                        "reacted_type": "skip"
                                      }),
                                      context,
                                    );
                                increaseSwipeCount(profiles.length);
                              },
                              icon: SvgPicture.asset(
                                'assets/svgs/ic_delete.svg',
                                color: Colors.red,
                                width: 32,
                              ),
                            ),
                            CommonIconButton(
                              onTap: () async {
                                var response = await ref
                                    .read(repositoryProvider)
                                    .saveProfileReact(
                                      jsonEncode({
                                        "reacted_user_id":
                                            profiles[selectedIndex]
                                                .id
                                                .toString(),
                                        "reacted_type": "like"
                                      }),
                                      context,
                                    );

                                var profileReactResponse =
                                    ProfileReactResponse.fromJson(
                                        jsonDecode(response.body));

                                if (profileReactResponse.data?.buyLike ??
                                    false) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => GetMoreLikesDialog(),
                                  );
                                } else {
                                  increaseSwipeCount(profiles.length);
                                  if (profileReactResponse.data?.matchData !=
                                      null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MatchScreen(
                                          matchProfileData: profileReactResponse
                                              .data?.matchData,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: Image.asset(
                                'assets/images/ic_love.png',
                                width: 32,
                              ),
                            ),
                            CommonIconButton(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                            findData:
                                                profiles[selectedIndex])));
                                // showDialog(
                                //     context: context,
                                //     builder: (context) =>
                                //         GetPremiumDialog());
                              },
                              backgroundColor: Colors.grey.withOpacity(0.1),
                              icon: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SvgPicture.asset(
                                  'assets/svgs/ic_information.svg',
                                  width: 18,
                                  height: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
                loading: () => Container(
                    height: context.heightPx * 0.6,
                    child: Center(child: SpinKitThreeBounce(color: Colors.pinkAccent,))),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),

              // isProfileBuilder ? ProfileBuilder() : InfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  increaseSwipeCount(int total) {
    log('total $total');
    log('selectedIndex $selectedIndex');
    if (total > selectedIndex) {
      log('Increate index');
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
                  },
                ));
      }
    } else {
      log('Last Index');
      ref.invalidate(findListNotifierProvider);
    }
    var sharedPrefs = ref.watch(sharedPrefProvider);
    var oldSwipeCount = sharedPrefs.getInt("swipeCount");
    var newSwipeCount = (oldSwipeCount ?? 0) + 1;

    log("newSwipeCount $newSwipeCount");

    if (newSwipeCount == 5) {
      sharedPrefs.setInt("swipeCount", 0);
      getProfileBuilderQuestion();
    } else {
      sharedPrefs.setInt("swipeCount", newSwipeCount);
    }
    ref.invalidate(swipeCountProvider);
  }

  getProfileBuilderQuestion() async {
    var response = await ref
        .read(repositoryProvider)
        .getProfileBuiderQuestion(jsonEncode({}), context);
    var profileBuilderQuestionResponse =
        ProfileBuilderResponse.fromJson(jsonDecode(response.body));
    setState(() {
      profileBuilderData = profileBuilderQuestionResponse.data;
      isProfileBuilder = true;
    });
  }
}
