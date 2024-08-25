import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/auth/auth_screen.dart';
import 'package:phoosar/src/features/auth/choose_gender_screen.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/features/onboarding_screen/onboarding_screen.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/strings.dart';

/// Page to redirect users to the appropreate page depending on the initial auth state
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    getInitialSession();
    super.initState();
  }

  Future<void> getInitialSession() async {
    // quick and dirty way to wait for the widget to mount
    await Future.delayed(Duration.zero);

    var token = ref.watch(sharedPrefProvider).getString(kTokenKey);
    try {
      if (token == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthScreen()),
          (route) => false,
        );
      } else {
        var recentOnboardingStatus =
            ref.watch(sharedPrefProvider).getString(kRecentOnboardingKey);
        log("Status " + recentOnboardingStatus.toString());
        if (recentOnboardingStatus == null ||
            recentOnboardingStatus == kProfileStatus) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ChooseGenderScreen()),
          );
        } else if (recentOnboardingStatus == kQuestionStatus) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OnBoardingScreen()),
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (_) {
      context.showErrorSnackBar(
        message: 'Error occured during session refresh',
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthScreen()),
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
