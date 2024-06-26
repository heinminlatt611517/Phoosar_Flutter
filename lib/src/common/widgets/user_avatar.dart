import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/providers/profile_provider.dart';

/// Widget that will display a user's avatar
class UserAvatar extends ConsumerWidget {
  final String userId;
  final bool fromChat;

  const UserAvatar({
    Key? key,
    required this.userId,
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
          color: Colors.blue, // Background color for the container
        ),
      ),
      error: (error, _) => ClipRRect(
        borderRadius: BorderRadius.circular(12), // Set the corner radius to 20
        child: Container(
          width: 50, // Specify the width
          height: 50, // Specify the height
          color: Colors.blue, // Background color for the container
        ),
      ),
      data: (profile) {
        if (profile == null) {
          return ClipRRect(
            borderRadius:
                BorderRadius.circular(12), // Set the corner radius to 20
            child: Container(
              width: 50, // Specify the width
              height: 50, // Specify the height
              color: Colors.blue, // Background color for the container
            ),
          );
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
                  ? profile.username.startsWith('S') ||
                          profile.username.startsWith('A') ||
                          profile.username.startsWith('H')
                      ? Image.asset(
                          'assets/images/sample_profile2.jpeg',
                          width: 46, // Specify the width
                          height: 50, // Specify the height
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/sample_profile.png',
                          width: 46, // Specify the width
                          height: 50, // Specify the height
                          fit: BoxFit.cover,
                        )
                  : Text(
                      profile.username.length > 3
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
