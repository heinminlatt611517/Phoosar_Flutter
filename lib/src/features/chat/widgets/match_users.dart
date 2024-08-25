import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/user_avatar.dart';
import 'package:phoosar/src/features/chat/chat_page.dart';
import 'package:phoosar/src/features/chat/models/profile.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/utils/dimens.dart';

class MatchUsers extends ConsumerWidget {
  const MatchUsers({
    Key? key,
    required this.matchUsers,
    required this.type,
  }) : super(key: key);

  final List<Profile> matchUsers;
  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: matchUsers.isNotEmpty,
          child: Text(
            'New ' + type,
            style: TextStyle(color: Colors.grey, fontSize: kTextRegular3x),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: matchUsers
                .map<Widget>((user) => InkWell(
                      onTap: () async {
                        log("User Id " + user.id);
                        log("User Name " + user.username);

                        try {
                          // Accessing RoomProvider to create a room
                          final roomId = await ref
                              .read(roomsProvider.notifier)
                              .createRoom(user.id);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatPage(
                                  roomId: roomId,
                                  otherUserName: user.username)));
                        } catch (e) {
                          log("Failed to create a new room: ${e.toString()}");
                        }
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 12, bottom: 8, top: 8),
                        child: SizedBox(
                          height: 140,
                          width: 140,
                          child: UserAvatar(
                            userId: user.id,
                            profileImage: '',
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
