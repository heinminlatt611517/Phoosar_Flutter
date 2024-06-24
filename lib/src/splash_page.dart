import 'package:flutter/material.dart';
import 'package:phoosar/src/features/auth/auth_screen.dart';
import 'package:phoosar/src/features/auth/register.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/settings/settings_controller.dart';
import 'package:phoosar/src/utils/constants.dart';

/// Page to redirect users to the appropreate page depending on the initial auth state
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.settingsController});
  final SettingsController settingsController;

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getInitialSession();
    super.initState();
  }

  Future<void> getInitialSession() async {
    // quick and dirty way to wait for the widget to mount
    await Future.delayed(Duration.zero);

    try {
      final session = supabase.auth.currentSession;
      if (session == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  AuthScreen(settingsController: widget.settingsController)),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(settingsController: widget.settingsController)),
          (route) => false,
        );
      }
    } catch (_) {
      context.showErrorSnackBar(
        message: 'Error occured during session refresh',
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                AuthScreen(settingsController: widget.settingsController)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: preloader,
    );
  }
}
