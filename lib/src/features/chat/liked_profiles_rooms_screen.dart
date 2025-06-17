import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phoosar/src/common/widgets/user_avatar.dart';
import 'package:phoosar/src/data/response/liked_you_list_response.dart';
import 'package:phoosar/src/features/chat/chat_page.dart';
import 'package:phoosar/src/features/chat/models/room.dart';
import 'package:phoosar/src/features/chat/widgets/match_users.dart';
import 'package:phoosar/src/features/other_profile/other_profile.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/chat_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/providers/profiles_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:sized_context/sized_context.dart';
import 'package:timeago/timeago.dart';

import '../../utils/colors.dart';

/// Displays the list of chat threads
class LikedProfilesRoomsScreen extends ConsumerWidget {
  const LikedProfilesRoomsScreen({
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
        child: SpinKitThreeBounce(color: primaryColor,),
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
                  onTap: (){
                     Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileScreen(findData: otherUser,isShowLikeButton: false,)));
                  },
                  child: UserAvatar(
                    userId: otherUser.supabaseUserId.toString(),
                    fromChat: true,
                    profileImage:otherUser.profileImages?.isNotEmpty ?? true ? otherUser.profileImages?.first ?? "" : errorImageUrl,
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

          },
          loading: () =>  Center(child:  SpinKitThreeBounce(color: primaryColor,)),
          error: (error, _) =>
              Center(child: Text('Error loading profiles: $error')),
        );
      },
    );
  }
}
