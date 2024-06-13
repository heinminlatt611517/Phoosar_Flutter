import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoosar/src/settings/settings_controller.dart';

class ScaffoldWithNavigationBar extends ConsumerWidget {
  const ScaffoldWithNavigationBar({
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.settingsController,
    required super.key,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        key: key,
        body: body,
        endDrawerEnableOpenDragGesture: false,
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onDestinationSelected(0);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/ic_home.svg',
                    width: 22,
                    height: 22,
                    color: selectedIndex == 0
                        ? Colors.cyan
                        : settingsController.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
              Container(
                width: 2,
                height: 32,
                color: Color(0xfff0f0f0),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onDestinationSelected(1);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/ic_chat.svg',
                    width: 22,
                    height: 22,
                    color: selectedIndex == 1
                        ? Colors.cyan
                        : settingsController.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
              Container(
                width: 2,
                height: 32,
                color: Color(0xfff0f0f0),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onDestinationSelected(2);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/ic_account.svg',
                    width: 22,
                    height: 22,
                    color: selectedIndex == 2
                        ? Colors.cyan
                        : settingsController.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
