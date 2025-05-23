import 'package:facebook_app_events/facebook_app_events.dart';

class FacebookAnalyticsService {
  FacebookAnalyticsService._internal();
  static final FacebookAnalyticsService instance =
  FacebookAnalyticsService._internal();

  final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _facebookAppEvents.logEvent(name: name, parameters: parameters);
  }

  Future<void> logPurchase({
    required double amount,
    required String currency,
  }) async {
    await _facebookAppEvents.logPurchase(amount: amount, currency: currency);
  }

  Future<void> logAddToCart({
    required String id,
    required String type,
    required double price,
    required String currency,
  }) async {
    await _facebookAppEvents.logAddToCart(
      id: id,
      type: type,
      price: price,
      currency: currency,
    );
  }

  Future<void> setUserData({
    String? email,
    String? firstName,
    String? dateOfBirth,
    String? city,
    String? country,
  }) async {
    await _facebookAppEvents.setUserData(
      email: email,
      firstName: firstName,
      dateOfBirth: dateOfBirth,
      city: city,
      country: country,
    );
  }

  Future<void> setAdvertiserTracking({required bool enabled}) async {
    await _facebookAppEvents.setAdvertiserTracking(enabled: enabled);
  }

  Future<String?> getAnonymousId() async {
    return await _facebookAppEvents.getAnonymousId();
  }
}
