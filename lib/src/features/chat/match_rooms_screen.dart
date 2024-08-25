import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phoosar/src/common/widgets/user_avatar.dart';
import 'package:phoosar/src/data/response/liked_you_list_response.dart';
import 'package:phoosar/src/data/response/match_list_response.dart';
import 'package:phoosar/src/features/chat/chat_page.dart';
import 'package:phoosar/src/features/chat/models/room.dart';
import 'package:phoosar/src/features/chat/widgets/match_users.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/chat_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/providers/profiles_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:timeago/timeago.dart';

/// Displays the list of chat threads
class MatchRoomsScreen extends ConsumerWidget {
  const MatchRoomsScreen({
    Key? key,
    required this.filterUsers,
  }) : super(key: key);
  final List<MatchData> filterUsers;

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
            final filterUserIds = filterUsers
                .map((user) => user.profile!.supabaseUserId)
                .toList();
            final matchUsers = profiles
                .where((p) =>
                    p.id != currentUserId && filterUserIds.contains(p.id))
                .toList();
            return ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: filterUsers.length,
              itemBuilder: (context, index) {
                Room? room = rooms
                    .where((room) =>
                        room.otherUserId ==
                        filterUsers[index].profile!.supabaseUserId)
                    .firstOrNull;
                var otherUser = filterUsers[index].profile!;
                return Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          if (room != null) {
                            await ref.read(repositoryProvider).saveProfileReact(
                                  jsonEncode({
                                    "reacted_user_id": filterUsers
                                        .firstWhere((user) =>
                                            user.profile!.supabaseUserId ==
                                            room.otherUserId)
                                        .id
                                        .toString(),
                                    "reacted_type": "block"
                                  }),
                                  context,
                                );
                            ref.invalidate(matchListProvider);
                            ref.invalidate(likeListProvider);
                            ref.invalidate(likedProfilesListProvider);
                          }
                        },
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        icon: Icons.block,
                      ),
                      SlidableAction(
                        onPressed: (_) async {
                          if (room != null) {
                            await ref
                                .read(chatProvider(room.id).notifier)
                                .deleteAllMessages();
                            ref.invalidate(roomsProvider);
                          }
                        },
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () async {
                      if (room == null) {
                        try {
                          // Accessing RoomProvider to create a room
                          final roomId = await ref
                              .read(roomsProvider.notifier)
                              .createRoom(filterUsers[index]
                                  .profile!
                                  .supabaseUserId
                                  .toString());
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatPage(
                                  roomId: roomId,
                                  otherUserName: filterUsers[index]
                                      .profile!
                                      .name
                                      .toString())));
                        } catch (e) {
                          log("Failed to create a new room: ${e.toString()}");
                        }
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                roomId: room.id,
                                otherUserName: otherUser.name.toString())));
                      }
                    },
                    leading: UserAvatar(
                      userId: otherUser.supabaseUserId.toString(),
                      fromChat: true,
                      profileImage: '',
                    ),
                    title: Text(otherUser.name.toString()),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        room != null
                            ? room.lastMessage?.content ?? 'Chat Room Created'
                            : 'Start Messaging',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(room != null
                          ? format(
                              room.lastMessage?.createdAt ?? room.createdAt,
                              locale: 'en_short')
                          : ''),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Colors.black,
              ),
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
