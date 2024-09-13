import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  bool isLoading = false;

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

  Future<void> _showLoadingDialog(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(20),
          contentPadding: EdgeInsets.all(10),
          content: Container(
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SpinKitThreeBounce(color: Colors.pinkAccent),
                SizedBox(width: 16),
                Text('Exiting app, please wait..', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (isLoading) return false;

    setState(() {
      isLoading = true;
    });

    await _showLoadingDialog(context);

    await _updateOnlineStatus(false);

    Navigator.of(context, rootNavigator: true).pop();

    SystemChannels.platform.invokeMethod('SystemNavigator.pop');

    return false;
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
      onWillPop: _onWillPop,
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
