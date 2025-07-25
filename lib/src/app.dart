import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/auth/auth_screen.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/settings/settings_controller.dart';
import 'package:phoosar/src/splash_page.dart';
import 'package:phoosar/src/utils/enable_drag.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fcm/fcm_service.dart';
import 'localization/app_localizations.dart';
import 'settings/settings_view.dart';

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.sharedPreferences,
    required this.navigatorKey
  });
  final SettingsController settingsController;
  final SharedPreferences sharedPreferences;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    FCMService().listenForMessages(sharedPreferences,ref);
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          navigatorKey: navigatorKey,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('my', ''),
          ],
          locale: Locale(ref.watch(localeProvider)),
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(fontFamily: kFontArticulatCFNormal),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case AuthScreen.routeName:
                    return AuthScreen();
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case HomeScreen.routeName:
                    return HomeScreen();
                  default:
                    return SplashScreen();
                }
              },
            );
          },
          scrollBehavior: MyCustomScrollBehavior(),
        );
      },
    );
  }
}
