import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/providers/profile_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../features/chat/models/profile.dart';

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
      loading: () => _buildAvatarPlaceholder(),
      error: (error, _) => _buildAvatarError(),
      data: (profile) => _buildAvatar(profile),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 50,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildAvatarError() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        errorImageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAvatar(Profile? profile) {
    if (profileImage.isEmpty) {
      return _buildInitialsAvatar(profile);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: fromChat
          ? CachedNetworkImage(
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              imageUrl: profileImage.isEmpty ? errorImageUrl : profileImage,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  strokeWidth: 2, // Adjust the thickness of the spinner
                  valueColor: AlwaysStoppedAnimation<Color>(
                      primaryColor), // Customize the color
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error,color: Colors.red,),
            )
          : _buildInitialsAvatar(profile),
    );
  }

  Widget _buildInitialsAvatar(Profile? profile) {
    final username = profile?.username;
    final usernameLength = username?.length ?? 0;
    final isLongUsername = usernameLength > 3;

    return Container(
      width: 50,
      height: 50,
      color: fromChat ? Colors.transparent : Colors.grey[300],
      child: Center(
        child: Text(
          isLongUsername ? username!.substring(0, 4) : username!,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }
}
