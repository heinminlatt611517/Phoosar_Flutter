import 'dart:convert';

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

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      /// The app is going to the background
      _updateOnlineStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      /// The app is coming to the foreground
      _updateOnlineStatus(true);
    }
    else if (state == AppLifecycleState.inactive) {
      /// The app is coming to the foreground
      _updateOnlineStatus(false);
    }
  }

  Future<void> _updateOnlineStatus(bool isOnline) async {
    debugPrint("IsOnline:::$isOnline");
    try {
      final repository = ref.watch(repositoryProvider);
      repository.saveOnlineStatus(
        jsonEncode({"is_online": isOnline}),
        context,
      );

    } catch (e) {
      print('Error: $e');
    }
  }

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
