import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/dashboard/dashboard.dart';
import 'package:phoosar/src/features/home/scaffold_with_navigation_bar.dart';
import 'package:phoosar/src/settings/settings_controller.dart';
import 'package:phoosar/src/settings/settings_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.settingsController});
  final SettingsController settingsController;
  static const routeName = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var pages = [
      DashboardScreen(controller: widget.settingsController),
      const Text('Chat'),
      SettingsView(controller: widget.settingsController),
    ];
    return ScaffoldWithNavigationBar(
      selectedIndex: selectedIndex,
      settingsController: widget.settingsController,
      onDestinationSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      key: const Key('home_scaffold'),
      body: pages[selectedIndex],
    );
  }
}
