import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoosar/src/common/widgets/icon_button.dart';
import 'package:phoosar/src/data/response/profile_react_response.dart';
import 'package:phoosar/src/features/dashboard/match.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_premium_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/header.dart';
import 'package:phoosar/src/features/dashboard/widgets/info_card.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool isProfileBuilder = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(repositoryProvider).saveOnlineStatus(
            jsonEncode({"is_online": true}),
            context,
          );
      fetchAndSetProfileData(ref, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var findList = ref.watch(findListProvider(context));
    var swipeCount = ref.watch(swipeCountProvider);
    var lastFindIds = ref.watch(lastFindIdsProvider);
    
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
              findList.when(data: (data) {
                return data == null
                    ? Container()
                    : Column(
                        children: [
                          InfoCard(findData: data),
                          20.vGap,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CommonIconButton(
                                onTap: () {
                                  increaseSwipeCount();

                                  var latestLastFindIds = lastFindIds.last;

                                  ref.read(repositoryProvider).saveProfileReact(
                                        jsonEncode({
                                          "reacted_user_id": latestLastFindIds,
                                          "reacted_type": "rewind"
                                        }),
                                        context,
                                      );
                                },
                                backgroundColor: Color(0xfff8f8f8),
                                icon: SvgPicture.asset(
                                  'assets/svgs/ic_backward.svg',
                                  width: 18,
                                ),
                              ),
                              CommonIconButton(
                                onTap: () {
                                  increaseSwipeCount();

                                  ref.read(repositoryProvider).saveProfileReact(
                                        jsonEncode({
                                          "reacted_user_id": data.id,
                                          "reacted_type": "skip"
                                        }),
                                        context,
                                      );
                                },
                                icon: SvgPicture.asset(
                                  'assets/svgs/ic_delete.svg',
                                  color: Colors.red,
                                  width: 28,
                                ),
                              ),
                              CommonIconButton(
                                onTap: () async {
                                  increaseSwipeCount();

                                  var response = await ref
                                      .read(repositoryProvider)
                                      .saveProfileReact(
                                        jsonEncode({
                                          "reacted_user_id": data.id,
                                          "reacted_type": "like"
                                        }),
                                        context,
                                      );

                                  var profileReactResponse =
                                      ProfileReactResponse.fromJson(
                                          jsonDecode(response.body));

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
                                },
                                icon: Image.asset(
                                  'assets/images/ic_love.png',
                                  width: 28,
                                ),
                              ),
                              CommonIconButton(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => GetPremiumDialog());
                                },
                                backgroundColor: Color(0xfff8f8f8),
                                icon: SvgPicture.asset(
                                  'assets/svgs/ic_information.svg',
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                            ],
                          )
                        ],
                      );
              }, error: (error, stack) {
                return Container();
              }, loading: () {
                return Container();
              }),
              // isProfileBuilder ? ProfileBuilder() : InfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  increaseSwipeCount() {
    var sharedPrefs = ref.watch(sharedPrefProvider);
    var oldSwipeCount = sharedPrefs.getInt("swipeCount");
    sharedPrefs.setInt("swipeCount", (oldSwipeCount ?? 0) + 1);
    ref.invalidate(swipeCountProvider);
  }
}
