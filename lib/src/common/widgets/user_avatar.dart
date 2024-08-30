import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/providers/profile_provider.dart';
import 'package:phoosar/src/utils/strings.dart';

/// Widget that will display a user's avatar
class UserAvatar extends ConsumerWidget {
  final String userId;
  final bool fromChat;
  final String profileImage;

  const UserAvatar({
    Key? key,
    required this.userId,
    required this.profileImage,
    this.fromChat = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider(userId));

    return profileState.when(
      loading: () => ClipRRect(
        borderRadius: BorderRadius.circular(12), // Set the corner radius to 20
        child: Container(
          width: 50, // Specify the width
          height: 50, // Specify the height
        ),
      ),
      error: (error, _) => ClipRRect(
          borderRadius:
              BorderRadius.circular(12), // Set the corner radius to 20
          child: Image.network(
            errorImageUrl, width: 46, // Specify the width
            height: 50, // Specify the height
            fit: BoxFit.cover,
          )),
      data: (profile) {
        if (profileImage.isEmpty) {
          return Container(
              width: 50, // Specify the width
              height: 50, // Specify the height

              //child: Image.network(profile.profileUrl),
              color: fromChat
                  ? Colors.transparent
                  : Color(0xffe0e0e0), // Background color for the container
              child: fromChat
                  ? Image.network(
                      errorImageUrl, width: 46, // Specify the width
                      height: 50, // Specify the height
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Text(
                        profile!.username.length > 3
                            ? profile.username.substring(0, 4)
                            : profile.username, // Display the initials
                        style: const TextStyle(
                            color: Colors.black, fontSize: 14), // Text color
                      ),
                    ));
        }
        return ClipRRect(
          borderRadius:
              BorderRadius.circular(12), // Set the corner radius to 20
          child: Container(
            width: 50, // Specify the width
            height: 50, // Specify the height

            //child: Image.network(profile.profileUrl),
            color: fromChat
                ? Colors.transparent
                : Color(0xffe0e0e0), // Background color for the container
            child: Center(
              child: fromChat
                  ? Image.network(
                      profileImage.isEmpty ? errorImageUrl : profileImage,
                      width: 106, // Specify the width
                      height: 100, // Specify the height
                      fit: BoxFit.cover,
                    )
                  : Text(
                      profile!.username.length > 3
                          ? profile.username.substring(0, 4)
                          : profile.username, // Display the initials
                      style: const TextStyle(
                          color: Colors.black, fontSize: 14), // Text color
                    ),
            ),
          ),
        );
      },
    );
  }
}
