import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/user_avatar.dart';
import 'package:phoosar/src/features/chat/chat_page.dart';
import 'package:phoosar/src/features/chat/widgets/match_users.dart';
import 'package:phoosar/src/providers/profiles_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/settings/settings_controller.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:timeago/timeago.dart';

/// Displays the list of chat threads
class RoomsScreen extends ConsumerWidget {
  const RoomsScreen({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomState = ref.watch(roomsProvider);
    final profilesState = ref.watch(profilesProvider);

    return roomState.when(
      loading: () => Center(
        child: Container(
          width: 50,
          height: 50,
          child: const CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (rooms) {
        return profilesState.when(
          data: (profiles) {
            final currentUserId = supabase.auth.currentUser!.id;
            final matchUsers =
                profiles.where((p) => p.id != currentUserId).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MatchUsers(matchUsers: matchUsers),
                Expanded(
                  child: ListView.separated(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      final otherUser =
                          profiles.firstWhere((p) => p.id != room.otherUserId);
                      return ListTile(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    roomId: room.id,
                                    otherUserName: otherUser.username))),
                        leading: UserAvatar(userId: otherUser.id),
                        title: Text(otherUser.username),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            room.lastMessage?.content ?? '-',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: Text(format(
                            room.lastMessage?.createdAt ?? room.createdAt,
                            locale: 'en_short')),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
          error: (error, _) =>
              Center(child: Text('Error loading profiles: $error')),
        );
      },
    );
  }
}
