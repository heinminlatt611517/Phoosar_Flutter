import 'package:flutter/services.dart';

class TikTokEvents {
  static const MethodChannel _channel = MethodChannel('tiktok_events');

  /// Track a custom event
  static Future<void> trackEvent(
      String eventName, {
        Map<String, dynamic>? properties,
      }) async {
    try {
      await _channel.invokeMethod('trackEvent', {
        'eventName': eventName,
        'properties': properties ?? {},
      });
    } on PlatformException catch (e) {
      print("Failed to track TikTok event: ${e.message}");
    }
  }

  /// Track a purchase event
  static Future<void> trackPurchase(
      double value,
      String currency, {
        Map<String, dynamic>? properties,
      }) async {
    try {
      await _channel.invokeMethod('trackPurchase', {
        'value': value,
        'currency': currency,
        'properties': properties ?? {},
      });
    } on PlatformException catch (e) {
      print("Failed to track TikTok purchase: ${e.message}");
    }
  }

  /// Set user data for tracking
  static Future<void> setUserData({
    String? externalId,
    String? email,
    String? phone,
  }) async {
    try {
      await _channel.invokeMethod('setUserData', {
        'externalId': externalId,
        'email': email,
        'phone': phone,
      });
    } on PlatformException catch (e) {
      print("Failed to set TikTok user data: ${e.message}");
    }
  }
}