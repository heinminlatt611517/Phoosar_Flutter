import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/settings/settings_controller.dart';
import 'package:phoosar/src/splash_page.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/enable_drag.dart';
import 'settings/settings_view.dart';

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: appTheme,
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);

                  case HomeScreen.routeName:
                    return HomeScreen(settingsController: settingsController);
                  default:
                    return SplashScreen(
                      settingsController: settingsController,
                    );
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
