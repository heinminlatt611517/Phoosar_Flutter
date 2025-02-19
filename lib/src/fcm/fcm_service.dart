import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/auth_screen.dart';
import '../providers/app_provider.dart';
import '../utils/strings.dart';

const localNotificationChannel = "high_importance_channel";
const localNotificationChannelTitle = "High Importance Notifications";
const localNotificationChannelDescription =
    "This channel is used for important notifications.";

class FCMService {
  static final FCMService _singleton = FCMService._internal();

  factory FCMService() {
    return _singleton;
  }

  FCMService._internal();

  /// Firebase Messaging Instance
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// Android Notification Channel
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    localNotificationChannel,
    localNotificationChannelTitle,
    description: localNotificationChannelDescription,
    importance: Importance.max,
  );

  /// Flutter Notification Plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Android Initialization Settings
  AndroidInitializationSettings initializationSettingsAndroid =
  const AndroidInitializationSettings('@mipmap/ic_launcher');

  GlobalKey<NavigatorState>? navigatorKey;

  void listenForMessages(SharedPreferences sharedPrefs,WidgetRef ref) async {
    await requestNotificationPermissionForIOS(sharedPrefs);
    await turnOnIOSForegroundNotification();

    await initFlutterLocalNotification(sharedPrefs,ref);
    await registerChannel();
    await FirebaseMessaging.instance.subscribeToTopic('phoosar');

    FirebaseMessaging.onMessage.listen((remoteMessage) {
      debugPrint("Notification Sent From Server while in foreground");
      RemoteNotification? notification = remoteMessage.notification;
      AndroidNotification? android = remoteMessage.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ),
          payload: remoteMessage.data['post_id'].toString(),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      debugPrint("User pressed the notification");
      doNavigationLogic(sharedPrefs,ref);
    });

    messaging.getInitialMessage().then((remoteMessage) {
      debugPrint("Message Launched ${remoteMessage?.data['post_id']}");
    });
  }

  Future requestNotificationPermissionForIOS(SharedPreferences sharedPrefs) async {
    messaging.getToken().then((fcmToken) {
      debugPrint("FCM Token for Device ======> $fcmToken");
      sharedPrefs.setString("fcmToken", fcmToken ?? "");
    });
    return messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future turnOnIOSForegroundNotification() {
    return FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onTapLocalNotification(NotificationResponse notificationResponse, SharedPreferences sharedPrefs,WidgetRef ref) async {
    await doNavigationLogic(sharedPrefs,ref);
  }

  Future<void> doNavigationLogic(SharedPreferences sharedPrefs,WidgetRef ref) async {
    var token = sharedPrefs.getString(kTokenKey);
    if (token == null) {
      navigatorKey?.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthScreen()),
            (route) => false,
      );
    } else {
      ref.read(dashboardProvider.notifier).setPosition(1);
    }
  }

  Future initFlutterLocalNotification(SharedPreferences sharedPrefs,WidgetRef ref) {
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );
    return flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) =>
          onTapLocalNotification(response, sharedPrefs,ref),
    );
  }

  Future? registerChannel() {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
