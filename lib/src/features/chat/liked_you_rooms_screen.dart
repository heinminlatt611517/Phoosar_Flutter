import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phoosar/src/common/widgets/user_avatar.dart';
import 'package:phoosar/src/data/response/liked_you_list_response.dart';
import 'package:phoosar/src/features/chat/chat_page.dart';
import 'package:phoosar/src/features/chat/models/room.dart';
import 'package:phoosar/src/features/other_profile/other_profile.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/chat_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/providers/profiles_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:timeago/timeago.dart';

/// Displays the list of chat threads
class LikedYouRoomsScreen extends ConsumerWidget {
  const LikedYouRoomsScreen({
    Key? key,
    required this.filterUsers,
  }) : super(key: key);
  final List<LikedYouData> filterUsers;

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

            return GridView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Room? room = rooms
                    .where((room) =>
                        room.otherUserId ==
                        filterUsers[index].profile!.supabaseUserId)
                    .firstOrNull;
                var otherUser = filterUsers[index].profile!;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(findData: otherUser)));
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => ChatPage(
                    //         roomId: room?.id ?? "",
                    //         otherProfileImage:
                    //             otherUser.profileImages?.first ?? "",
                    //         otherUserName: otherUser.name.toString())));
                  },
                  child: UserAvatar(
                    userId: otherUser.supabaseUserId.toString(),
                    fromChat: true,
                    profileImage: otherUser.profileImages?.first ?? "",
                  ),
                );
              },
              itemCount: filterUsers.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // number of items in each row
                mainAxisSpacing: 20.0, // spacing between rows
                crossAxisSpacing: 10.0,
              ),
            );

            // return ListView.separated(
            //   padding: EdgeInsets.zero,
            //   itemCount: filterUsers.length,
            //   itemBuilder: (context, index) {
            //     Room? room = rooms
            //         .where((room) =>
            //             room.otherUserId ==
            //             filterUsers[index].profile!.supabaseUserId)
            //         .firstOrNull;
            //     var otherUser = filterUsers[index].profile!;
            //     return Slidable(
            //       key: ValueKey(index),
            //       endActionPane: ActionPane(
            //         motion: const ScrollMotion(),
            //         children: [
            //           SlidableAction(
            //             onPressed: (_) async {
            //               if (room != null) {
            //                 await ref.read(repositoryProvider).saveProfileReact(
            //                       jsonEncode({
            //                         "reacted_user_id": filterUsers
            //                             .firstWhere((user) =>
            //                                 user.profile!.supabaseUserId ==
            //                                 room.otherUserId)
            //                             .profile!
            //                             .id
            //                             .toString(),
            //                         "reacted_type": "block"
            //                       }),
            //                       context,
            //                     );
            //                 ref.invalidate(matchListProvider);
            //                 ref.invalidate(likeListProvider);
            //                 ref.invalidate(likedProfilesListProvider);
            //               }
            //             },
            //             backgroundColor: Colors.grey,
            //             foregroundColor: Colors.white,
            //             icon: Icons.block,
            //           ),
            //           SlidableAction(
            //             onPressed: (_) async {
            //               if (room != null) {
            //                 await ref
            //                     .read(chatProvider(room.id).notifier)
            //                     .deleteRoom();
            //                 ref.invalidate(roomsProvider);
            //               }
            //             },
            //             backgroundColor: Colors.pinkAccent,
            //             foregroundColor: Colors.white,
            //             icon: Icons.delete,
            //           ),
            //         ],
            //       ),
            //       child: ListTile(
            //         contentPadding: EdgeInsets.zero,
            //         onTap: () async {
            //           if (room == null) {
            //             // try {
            //             //   // Accessing RoomProvider to create a room
            //             //   final roomId = await ref
            //             //       .read(roomsProvider.notifier)
            //             //       .createRoom(filterUsers[index]
            //             //           .profile!
            //             //           .supabaseUserId
            //             //           .toString());
            //             //   Navigator.of(context).push(MaterialPageRoute(
            //             //       builder: (context) => ChatPage(
            //             //           roomId: roomId,
            //             //           otherUserName: filterUsers[index]
            //             //               .profile!
            //             //               .name
            //             //               .toString())));
            //             // } catch (e) {
            //             //   log("Failed to create a new room: ${e.toString()}");
            //             // }
            //           } else {
            //             Navigator.of(context).push(MaterialPageRoute(
            //                 builder: (context) => ChatPage(
            //                     roomId: room.id,
            //                     otherUserName: otherUser.name.toString())));
            //           }
            //         },
            //         leading: UserAvatar(
            //           userId: otherUser.supabaseUserId.toString(),
            //           fromChat: true,
            //           profileImage: '',
            //         ),
            //         title: Text(otherUser.name.toString()),
            //         subtitle: Padding(
            //           padding: const EdgeInsets.only(top: 4),
            //           child: Text(
            //             room != null
            //                 ? room.lastMessage?.content ?? 'Chat Room Created'
            //                 : '',
            //             maxLines: 1,
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //         ),
            //         trailing: Padding(
            //           padding: const EdgeInsets.only(right: 12),
            //           child: Text(room != null
            //               ? format(
            //                   room.lastMessage?.createdAt ?? room.createdAt,
            //                   locale: 'en_short')
            //               : ''),
            //         ),
            //       ),
            //     );
            //   },
            //   separatorBuilder: (context, index) => const Divider(
            //     height: 1,
            //     color: Colors.black,
            //   ),
            // );
          },
          loading: () => Container(),
          error: (error, _) =>
              Center(child: Text('Error loading profiles: $error')),
        );
      },
    );
  }
}
