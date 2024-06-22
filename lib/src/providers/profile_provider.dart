import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/models/profile.dart';
import 'package:phoosar/src/providers/app_provider.dart';

final profileProvider =
    StateNotifierProvider.family<ProfileNotifier, AsyncValue<Profile?>, String>(
  (ref, userId) => ProfileNotifier(ref, userId),
);

class ProfileNotifier extends StateNotifier<AsyncValue<Profile?>> {
  final Ref _ref;
  final String userId;

  ProfileNotifier(this._ref, this.userId) : super(const AsyncValue.loading()) {
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final response = await _ref
          .read(supabaseClientProvider)
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      final profile = Profile.fromMap(response);
      state = AsyncValue.data(profile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
