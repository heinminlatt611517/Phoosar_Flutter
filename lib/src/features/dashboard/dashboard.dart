import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoosar/src/common/widgets/icon_button.dart';
import 'package:phoosar/src/features/dashboard/widgets/header.dart';
import 'package:phoosar/src/features/dashboard/widgets/info_card.dart';
import 'package:phoosar/src/features/dashboard/widgets/profile_builder.dart';
import 'package:phoosar/src/settings/settings_controller.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.controller});
  final SettingsController controller;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isProfileBuilder = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.controller.themeMode == ThemeMode.dark
          ? blackColor
          : whitePaleColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DashboardHeader(),
              isProfileBuilder ? ProfileBuilder() : InfoCard(),
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
                    onTap: () {},
                    icon: Image.asset(
                      'assets/images/ic_love.png',
                      width: 28,
                    ),
                  ),
                  CommonIconButton(
                    onTap: () {},
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
