import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/user_avatar.dart';
import 'package:phoosar/src/features/chat/models/message.dart';
import 'package:phoosar/src/providers/chat_provider.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:timeago/timeago.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String roomId;
  final String otherUserName;
  const ChatPage({Key? key, required this.roomId, required this.otherUserName})
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

    return Scaffold(
      appBar: AppBar(title: Text(otherUserName)),
      body: chatState.when(
        loading: () => preloader,
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (messages) {
          if (messages.isEmpty) {
            return Column(
              children: [
                const Expanded(
                  child: Center(
                    child: Text('Start your conversation now :)'),
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
                      return _ChatBubble(message: message);
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
                  hintText: 'Type a message',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
            TextButton(
              onPressed: _submitMessage,
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      UserAvatar(
        userId: message.profileId,
        fromChat: true,
        profileImage: '',
      ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? Colors.blue : Colors.grey[300],
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
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
