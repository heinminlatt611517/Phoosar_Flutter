import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/models/profile.dart';
import 'package:phoosar/src/providers/app_provider.dart';

final profilesProvider =
    StateNotifierProvider<ProfilesNotifier, AsyncValue<List<Profile>>>(
  (ref) => ProfilesNotifier(ref),
);

class ProfilesNotifier extends StateNotifier<AsyncValue<List<Profile>>> {
  final Ref _ref;

  ProfilesNotifier(this._ref) : super(const AsyncValue.loading()) {
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    try {
      final response =
          await _ref.read(supabaseClientProvider).from('profiles').select();
      List<Profile> profiles = response
          .map<Profile>((profileData) => Profile.fromMap(profileData))
          .toList();
      state = AsyncValue.data(profiles);
    } catch (e, stackTrace) {
      throw e;
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
