import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoosar/src/common/widgets/icon_button.dart';
import 'package:phoosar/src/features/dashboard/widgets/info_card.dart';
import 'package:phoosar/src/settings/settings_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.controller});
  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.themeMode == ThemeMode.dark
          ? Colors.black
          : Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey),
                        color: Color(0xfff0f0f0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.heart_broken,
                            size: 15,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '100',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/images/ic_launcher.png',
                          width: 42,
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InfoCard(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CommonIconButton(
                    onTap: () {},
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
