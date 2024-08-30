import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/chat_screen.dart';
import 'package:phoosar/src/features/dashboard/dashboard.dart';
import 'package:phoosar/src/features/home/scaffold_with_navigation_bar.dart';
import 'package:phoosar/src/features/user_profile/user_profile.dart';
import 'package:phoosar/src/providers/app_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
  });
  static const routeName = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(dashboardProvider);
    var pages = [
      DashboardScreen(),
      ChatScreen(),
      UserProfileScreen(),
      // SettingsView(controller: widget.settingsController),
    ];
    return ScaffoldWithNavigationBar(
      selectedIndex: position,
      onDestinationSelected: (index) {
        setState(() {
          ref.read(dashboardProvider.notifier).setPosition(index);
        });
      },
      key: const Key('home_scaffold'),
      body: pages[position],
    );
  }
}
