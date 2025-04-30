import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phoosar/src/common/widgets/user_avatar.dart';
import 'package:phoosar/src/data/response/match_list_response.dart';
import 'package:phoosar/src/features/chat/chat_page.dart';
import 'package:phoosar/src/features/chat/models/room.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/chat_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/providers/profiles_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:sized_context/sized_context.dart';

import 'models/message.dart';

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
      loading: () => Container(
        height: context.heightPx * 0.5,
        child: Center(child: SpinKitThreeBounce(color: primaryColor)),
      ),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (rooms) {
        return profilesState.when(
          data: (profiles) {
            return ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: filterUsers.length,
              itemBuilder: (context, index) {
                Room? room = rooms
                    .where((room) => room.otherUserId == filterUsers[index].profile!.supabaseUserId)
                    .firstOrNull;

                var otherUser = filterUsers[index].profile!;
                return Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.4,
                    children: [
                      CustomSlidableAction(
                        onPressed: (_) async {
                          if (room != null) {
                            await ref.read(repositoryProvider).saveProfileReact(
                              jsonEncode({
                                "reacted_user_id": filterUsers
                                    .firstWhere((user) => user.profile!.supabaseUserId == room.otherUserId)
                                    .profile!
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
                        borderRadius: BorderRadius.circular(16),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(kMarginMedium3),
                        child: Image.asset(
                          'assets/images/report.png',
                          color: whiteColor,
                        ),
                      ),
                      6.hGap,
                      CustomSlidableAction(
                        onPressed: (_) async {
                          if (room != null) {
                            await ref.read(roomsProvider.notifier).deleteRoom(room.id);
                            ref.invalidate(roomsProvider);
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(22),
                        child: Image.asset(
                          'assets/images/delete_icon.png',
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () async {
                      if (room != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                roomId: room.id,
                                otherProfileImage: otherUser.profileImages?.first.toString() ?? "",
                                otherUserName: otherUser.name.toString())));
                      } else {
                        try {
                          final roomId = await ref.read(roomsProvider.notifier).createRoom(
                              filterUsers[index].profile!.supabaseUserId.toString());
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatPage(
                                  roomId: roomId,
                                  otherProfileImage: filterUsers[index].profile!.profileImages?.first.toString() ?? "",
                                  otherUserName: filterUsers[index].profile!.name.toString())));
                        } catch (e) {
                          log("Failed to create a new room: ${e.toString()}");
                        }
                      }
                    },
                    leading: UserAvatar(
                      userId: otherUser.supabaseUserId.toString(),
                      fromChat: true,
                      profileImage: otherUser.profileImages?.first ?? "",
                    ),
                    title: Row(
                      children: [
                        Text(
                          otherUser.name.toString(),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        15.hGap,
                        Row(
                          children: [
                            Container(
                              height: 6,
                              width: 6,
                              decoration: BoxDecoration(
                                  color: otherUser.isOnline == 1 ? greenColor : Colors.transparent,
                                  shape: BoxShape.circle),
                            ),
                            5.hGap,
                            Text(
                              otherUser.isOnline == 1 ? 'online' : '',
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        room != null
                            ? _isImageMessage(room.lastMessage)
                            ? '${otherUser.name.toString()} sent a photo.'
                            : (room.lastMessage?.content ?? 'Chat Room Created')
                            : 'Start Messaging',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Consumer(
                      builder: (context, ref, child) {
                        final roomAsync = ref.watch(roomsProvider);
                        return roomAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (error, stack) => const SizedBox.shrink(),
                          data: (rooms) {
                            final currentRoom = rooms.firstWhere(
                                  (r) => r.id == room?.id,
                              orElse: () => Room(id: '', otherUserId: '', unreadCount: 0, lastMessage: null, createdAt: DateTime.now())
                            );
                            if (currentRoom == null || currentRoom.unreadCount <= 0) return const SizedBox.shrink();

                            return Padding(
                              padding: const EdgeInsets.only(top: 10, right: 10),
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    currentRoom.unreadCount > 9 ? '9+' : currentRoom.unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2, // Better vertical centering
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 10,
                color: Colors.transparent,
              ),
            );

          },
          loading: () => Container(),
          error: (error, _) => Center(child: Text('Error loading profiles: $error')),
        );
      },
    );
  }
}

bool _isImageMessage(Message? message) {
  return message != null && message.imageUrl != null && message.imageUrl!.isNotEmpty;
}
