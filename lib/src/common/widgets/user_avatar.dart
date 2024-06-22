import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/providers/profile_provider.dart';

/// Widget that will display a user's avatar
class UserAvatar extends ConsumerWidget {
  final String userId;

  const UserAvatar({
    Key? key,
    required this.userId,
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
            width: 60, // Specify the width
            height: 60, // Specify the height
            color: Colors.blue, // Background color for the container
            child: Center(
              child: Text(
                profile.username.substring(0, 2), // Display the initials
                style: const TextStyle(
                    color: Colors.white, fontSize: 16), // Text color
              ),
            ),
          ),
        );
      },
    );
  }
}
