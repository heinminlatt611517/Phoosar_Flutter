import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/user_avatar.dart';
import 'package:phoosar/src/features/chat/models/message.dart';
import 'package:phoosar/src/providers/chat_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:timeago/timeago.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/widgets/common_button.dart';
import '../../providers/data_providers.dart';
import '../../providers/room_provider.dart';
import '../../utils/fonts.dart';

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
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 20,)),
        title: Text(
          otherUserName,
          style: TextStyle(fontFamily: kFontGibsonBold,color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async{
              await ref
                  .read(chatProvider(roomId).notifier)
                  .deleteRoom();
              ref.invalidate(roomsProvider);
            },
            child: Image.asset(
              'assets/images/chat_delete.png',
              width: 20,
              height: 20,
            ),
          ),
          20.hGap
        ],
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
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.withOpacity(0.5),
                              fontSize: 24),
                        ),
                        20.vGap,
                        CommonButton(
                            bgColor: primaryColor,
                            text: 'Tap to Say "Hello"'.toUpperCase(),
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
      color: appBackgroundColor,
      child: Padding(
        padding: EdgeInsets.only(
          top: 8,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            Divider(color: Colors.black12,height: 5,),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    autofocus: false,
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: kMarginMedium2,vertical: kMarginMedium2),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _submitMessage,
                  child: const Icon(Icons.arrow_forward,color: Colors.black26,size: 30,),
                ),
              ],
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
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: message.isMine ? primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: message.isMine
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ]
                    : [],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontSize: 16,
                  color: message.isMine ? Colors.white : Colors.black,
                ),
              ),
            ),
            Align(
              alignment: message.isMine ? Alignment.topRight : Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  format(message.createdAt, locale: 'en_short'),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: message.isMine ? TextAlign.right : TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
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



