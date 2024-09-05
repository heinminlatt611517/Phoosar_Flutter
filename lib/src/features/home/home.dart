import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/chat_screen.dart';
import 'package:phoosar/src/features/dashboard/dashboard.dart';
import 'package:phoosar/src/features/home/scaffold_with_navigation_bar.dart';
import 'package:phoosar/src/features/user_profile/user_profile.dart';
import 'package:phoosar/src/providers/app_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
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
    debugPrint("ApplicationState:::${state}");
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _updateOnlineStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      _updateOnlineStatus(true);
    }
  }

  Future<void> _updateOnlineStatus(bool isOnline) async {
    debugPrint("IsOnline:::$isOnline");
    try {
      final repository = ref.watch(repositoryProvider);
      await repository.saveOnlineStatus(
        jsonEncode({"is_online": isOnline}),
        context,
      );
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    bool shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(20),
          title: Text('Exit App'),
          content: Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;

    if (shouldExit) {
      await _updateOnlineStatus(false);
    }

    return shouldExit;
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

    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context);
      },
      child: ScaffoldWithNavigationBar(
        selectedIndex: position,
        onDestinationSelected: (index) {
          setState(() {
            ref.read(dashboardProvider.notifier).setPosition(index);
          });
        },
        key: const Key('home_scaffold'),
        body: pages[position],
      ),
    );
  }
}
