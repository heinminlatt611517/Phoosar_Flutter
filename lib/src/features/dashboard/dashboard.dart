import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoosar/src/common/widgets/icon_button.dart';
import 'package:phoosar/src/features/dashboard/match.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_premium_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/header.dart';
import 'package:phoosar/src/features/dashboard/widgets/info_card.dart';
import 'package:phoosar/src/features/dashboard/widgets/profile_builder.dart';
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
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(repositoryProvider).saveOnlineStatus(
            jsonEncode({"is_online": true}),
            context,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    var findList = ref.watch(findListProvider(context));
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
                return data.isEmpty
                    ? Container()
                    : InfoCard(findData: data[selectedIndex]);
              }, error: (error, stack) {
                return Container();
              }, loading: () {
                return Container();
              }),
              // isProfileBuilder ? ProfileBuilder() : InfoCard(),
              20.vGap,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CommonIconButton(
                    onTap: () {
                      setState(() {
                        isProfileBuilder = !isProfileBuilder;
                      });
                    },
                    backgroundColor: Color(0xfff8f8f8),
                    icon: SvgPicture.asset(
                      'assets/svgs/ic_backward.svg',
                      width: 18,
                    ),
                  ),
                  CommonIconButton(
                    onTap: () {},
                    icon: SvgPicture.asset(
                      'assets/svgs/ic_delete.svg',
                      color: Colors.red,
                      width: 28,
                    ),
                  ),
                  CommonIconButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchScreen(),
                        ),
                      );
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
          ),
        ),
      ),
    );
  }
}
