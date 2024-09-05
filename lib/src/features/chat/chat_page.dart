import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/user_avatar.dart';
import 'package:phoosar/src/features/chat/models/message.dart';
import 'package:phoosar/src/providers/chat_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:timeago/timeago.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/widgets/common_button.dart';
import '../../providers/data_providers.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String roomId;
  final String otherUserName;
  final String otherProfileImage;
  const ChatPage(
      {Key? key,
      required this.roomId,
      required this.otherUserName,
      required this.otherProfileImage})
      : super(key: key);

  // static Route<void> route(String roomId, String otherUserName) {
  //   return MaterialPageRoute(
  //     builder: (context) => ProviderScope(
  //       overrides: [
  //         chatProvider(roomId).overrideWithProvider(
  //             StateNotifierProvider<ChatNotifier, AsyncValue<List<Message>>>(
  //                 (ref) => ChatNotifier(ref, roomId))),
  //       ],
  //       child: ChatPage(roomId: roomId, otherUserName: otherUserName),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider(roomId));
    var selfProfileData = ref.watch(selfProfileProvider);

    return Scaffold(
      backgroundColor: whitePaleColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: whitePaleColor,
        title: Text(otherUserName),
        elevation: 0.5,
      ),
      body: chatState.when(
        loading: () => preloader,
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (messages) {
          if (messages.isEmpty) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Say "Hello" to $otherUserName',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.withOpacity(0.5),
                              fontSize: 18),
                        ),
                        20.vGap,
                        CommonButton(
                            bgColor: Colors.pinkAccent,
                            text: 'Tap to Say "Hello"',
                            onTap: () {
                              final notifier =
                                  ref.read(chatProvider(roomId).notifier);
                              notifier.sendMessage("Hello");
                            })
                      ],
                    ),
                  ),
                ),
                _MessageBar(roomId: roomId),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _ChatBubble(
                        message: message,
                        otherProfileImage: otherProfileImage,
                        profileImage:
                            selfProfileData?.data?.profileImages?.first ??
                                ""
                                    "",
                      );
                    },
                  ),
                ),
                _MessageBar(roomId: roomId),
              ],
            );
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends ConsumerStatefulWidget {
  final String roomId;
  const _MessageBar({Key? key, required this.roomId}) : super(key: key);

  @override
  ConsumerState<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<_MessageBar> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage() {
    final text = _textController.text;
    if (text.isEmpty) {
      return;
    }
    final notifier = ref.read(chatProvider(widget.roomId).notifier);
    notifier.sendMessage(text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: EdgeInsets.only(
          top: 8,
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                maxLines: null,
                autofocus: true,
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
            TextButton(
              onPressed: _submitMessage,
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble(
      {Key? key,
      required this.message,
      required this.otherProfileImage,
      required this.profileImage})
      : super(key: key);

  final Message message;
  final String otherProfileImage;
  final String profileImage;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      UserAvatar(
        userId: message.profileId,
        fromChat: true,
        profileImage: message.isMine ? profileImage : otherProfileImage,
      ),
      const SizedBox(width: 12),
      Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: message.isMine
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 60,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: message.isMine ? Colors.pinkAccent : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontSize: 16,
                  color: message.isMine ? Colors.white : Colors.black,
                ),
              ),
            ),
            Text(
                style: TextStyle(color: Colors.grey),
                format(
                  message.createdAt,
                  locale: 'en_short',
                )),
          ],
        ),
      ),
      //const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
