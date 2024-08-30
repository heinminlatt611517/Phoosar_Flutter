import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phoosar/src/common/widgets/user_avatar.dart';
import 'package:phoosar/src/features/chat/chat_page.dart';
import 'package:phoosar/src/features/chat/widgets/match_users.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/chat_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/providers/profiles_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:timeago/timeago.dart';

/// Displays the list of chat threads
class RoomsScreen extends ConsumerWidget {
  const RoomsScreen(
      {Key? key, required this.filterUserIds, required this.filterUserImages})
      : super(key: key);
  final List<String> filterUserIds;
  final List<String> filterUserImages;

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
            final matchUsers = profiles
                .where((p) =>
                    p.id != currentUserId && filterUserIds.contains(p.id))
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MatchUsers(matchUsers: matchUsers, type: 'Matches'),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      final otherUser =
                          profiles.firstWhere((p) => p.id == room.otherUserId);
                      return Slidable(
                        key: ValueKey(index),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) async {
                                await ref
                                    .read(repositoryProvider)
                                    .saveProfileReact(
                                      jsonEncode({
                                        "reacted_user_id": room.otherUserId,
                                        "reacted_type": "block"
                                      }),
                                      context,
                                    );
                                ref.invalidate(matchListProvider);
                                ref.invalidate(likeListProvider);
                                ref.invalidate(likedProfilesListProvider);
                              },
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              icon: Icons.block,
                            ),
                            SlidableAction(
                              onPressed: (_) async {
                                await ref
                                    .read(chatProvider(room.id).notifier)
                                    .deleteAllMessages();
                                ref.invalidate(roomsProvider);
                              },
                              backgroundColor: Colors.pinkAccent,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                      roomId: room.id,
                                      otherProfileImage: otherUser.profileUrl,
                                      otherUserName: otherUser.username))),
                          leading: UserAvatar(
                            userId: otherUser.id,
                            fromChat: true,
                            profileImage: '',
                          ),
                          title: Text(otherUser.username),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              room.lastMessage?.content ?? 'Chat Room Created',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(format(
                                room.lastMessage?.createdAt ?? room.createdAt,
                                locale: 'en_short')),
                          ),
                        ),
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
          loading: () => Container(),
          error: (error, _) =>
              Center(child: Text('Error loading profiles: $error')),
        );
      },
    );
  }
}
