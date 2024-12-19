import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/env/env.dart';
import 'package:phoosar/firebase_options.dart';
import 'package:phoosar/src/fcm/fcm_service.dart';
import 'package:phoosar/src/fcm/fcm_token_generation.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController(SettingsService());
  // await Firebase.initializeApp();
  // debugPrint("FCMServerKey:::${await FirebaseAccessToken().getToken()}");
  // FCMService().listenForMessages();

  await settingsController.loadSettings();
  setPathUrlStrategy();
  registerErrorHandlers();
  final sharedPref = await SharedPreferences.getInstance();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } else {
    await Firebase.initializeApp(
        name: "phoosar", options: DefaultFirebaseOptions.currentPlatform);
  }

  await Supabase.initialize(
    url: Env.supabaseBaseUrl,
    anonKey: Env.supabaseAnonDataKey,
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefProvider.overrideWith((ref) => sharedPref),
      ],
      child: MyApp(settingsController: settingsController),
    ),
  );
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'),
      ),
      body: Center(
        child: SingleChildScrollView(
          // Added to provide bounded constraints
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(details.toString()),
          ),
        ),
      ),
    );
  };
}


class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermission(); // Request permission when the app starts
  }

  // Requesting Notification Permission
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission granted for notifications.");
    } else {
      print("Permission denied for notifications.");
    }
  }

  // Function to open notification settings
  void openNotificationSettings() {
    //AppSettings.openNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Want to manage push notifications?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: openNotificationSettings,
              child: Text('Go to Notification Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
