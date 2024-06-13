//sharedPreference provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/settings/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefProvider = StateProvider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final settingsControllerProvider = StateProvider<SettingsController>((ref) {
  throw UnimplementedError();
});