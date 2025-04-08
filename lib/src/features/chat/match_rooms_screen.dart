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
            final currentUserId = supabase.auth.currentUser!.id;
            final filterUserIds = filterUsers
                .map((user) => user.profile!.supabaseUserId)
                .toList();
            final matchUsers = profiles
                .where((p) => p.id != currentUserId && filterUserIds.contains(p.id))
                .toList();
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
                            await ref.read(chatProvider(room.id).notifier).deleteRoom();
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
                        await ref.read(chatProvider(room.id).notifier).markRoomAsRead();
                        ref.read(chatProvider(room.id).notifier).onEnterChatScreen();

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                roomId: room.id,
                                otherProfileImage: otherUser.profileImages?.first.toString() ?? "",
                                otherUserName: otherUser.name.toString())));
                      } else {
                        try {
                          final roomId = await ref.read(roomsProvider.notifier).createRoom(
                              filterUsers[index].profile!.supabaseUserId.toString());
                          await ref.read(chatProvider(roomId).notifier).markRoomAsRead();
                          ref.read(chatProvider(roomId).notifier).onEnterChatScreen();
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
                            ? room.lastMessage?.content ?? 'Chat Room Created'
                            : 'Start Messaging',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 10,right: 10),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            room != null ? room.unreadCount.toString() : '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
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
