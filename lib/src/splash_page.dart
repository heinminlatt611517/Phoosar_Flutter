import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:phoosar/src/data/response/show_buy_coin_response.dart';
import 'package:phoosar/src/features/auth/auth_screen.dart';
import 'package:phoosar/src/features/auth/choose_gender_screen.dart';
import 'package:phoosar/src/features/auth/welcome_screen.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/features/onboarding_screen/onboarding_screen.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchConfigData();
      getInitialSession();
    });
    super.initState();
  }

  ///fetch config data
  Future<void> _fetchConfigData() async {
    final response = await ref.read(repositoryProvider).checkPhoosarApp(
      context,
    );
    var data = ShowBuyCoinResponse.fromJson(jsonDecode(response.body));
    ref.read(checkPhoosarAppProvider.notifier).state = data.data ?? 0;
  }

  Future<void> getInitialSession() async {
    await Future.delayed(Duration.zero);

    if(ref.watch(checkPhoosarAppProvider).toString() == '0'){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
            home: WelcomeScreen())),
            (route) => false,
      );
    }
    else{
      var token = ref.watch(sharedPrefProvider).getString(kTokenKey);
      try {
        if (token == null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AuthScreen()),
                (route) => false,
          );
        } else {
          debugPrint("TokenIsNotNull");
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AuthScreen()),
                (route) => false,
          );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: preloader,
    );
  }
}
