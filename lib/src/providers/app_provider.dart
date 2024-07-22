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
