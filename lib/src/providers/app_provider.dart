//sharedPreference provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/data/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sharedPrefProvider = StateProvider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final supabaseClientProvider = StateProvider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final repositoryProvider = StateProvider<Repository>((ref) {
  return Repository(ref);
});

final localeProvider = StateProvider<String>((ref) {
  var sharedPrefs = ref.watch(sharedPrefProvider);
  var locale = sharedPrefs.getString("locale");
  return locale ?? "my";
});

final swipeCountProvider = StateProvider<int>((ref) {
  var sharedPrefs = ref.watch(sharedPrefProvider);
  var swipeCount = sharedPrefs.getInt("swipeCount");
  return swipeCount ?? 0;
});

final lastFindIdsProvider = StateProvider<List<String>>((ref) {
  var sharedPrefs = ref.watch(sharedPrefProvider);
  var lastFindIds = sharedPrefs.getStringList("lastFindIds");
  return lastFindIds ?? [];
});

final locationProvider = StateProvider<String>((ref) {
  var sharedPrefs = ref.watch(sharedPrefProvider);
  var userLocation = sharedPrefs.getString("userLocation");
  return userLocation ?? "";
});
