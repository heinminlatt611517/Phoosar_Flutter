import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phoosar/src/common/widgets/custom_style_arrow_view.dart';
import 'package:phoosar/src/common/widgets/user_avatar.dart';
import 'package:phoosar/src/features/chat/models/message.dart';
import 'package:phoosar/src/features/chat/video_call_page.dart';
import 'package:phoosar/src/providers/chat_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart';

import '../../common/widgets/common_button.dart';
import '../../providers/data_providers.dart';
import '../../providers/room_provider.dart';
import '../../utils/fonts.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String roomId;
  final String otherUserName;
  final String otherProfileImage;
  const ChatPage(
      {Key? key,
        required this.roomId,
        required this.otherUserName,
        required this.otherProfileImage})
      : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {

  @override
  void initState() {
    super.initState();
    ref.read(chatProvider(widget.roomId).notifier).onChatScreenOpened();
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider(widget.roomId));
    var selfProfileData = ref.watch(selfProfileProvider);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          backgroundColor: blackColor,
          leading: InkWell(
              onTap: (){
                ref.read(chatProvider(widget.roomId).notifier).onChatScreenClosed();
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 20,)),
          title: Text(
            widget.otherUserName,
            style: TextStyle(fontFamily: kFontGibsonBold,color: Colors.white),
          ),
          centerTitle: true,
          actions: [

            // ///video
            // IconButton(
            //   icon: Icon(Icons.videocam, color: Colors.white,size: 30,),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => VideoCallPage(roomId: widget.roomId,otherProfileImage: widget.otherProfileImage,otherUserName: widget.otherUserName,),
            //       ),
            //     );
            //   },
            // ),
            // 10.hGap,

            ///delete
            InkWell(
              onTap: () async{
                await ref.read(roomsProvider.notifier).deleteRoom(widget.roomId);
                ref.invalidate(roomsProvider);
                Navigator.pop(context);
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
                            'Say "Hello" to ${widget.otherUserName}',
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
                                ref.read(chatProvider(widget.roomId).notifier);
                                notifier.sendMessage("Hello");
                              })
                        ],
                      ),
                    ),
                  ),
                  _MessageBar(roomId: widget.roomId),
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
                          otherProfileImage: widget.otherProfileImage,
                          profileImage:
                          selfProfileData?.data?.profileImages?.first ??
                              ""
                                  "",
                        );
                      },
                    ),
                  ),
                  _MessageBar(roomId: widget.roomId),
                ],
              );
            }
          },
        ),
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
  bool _showEmojiPicker = false;
  late final FocusNode _focusNode;
  List<File> images = [];

  @override
  void initState() {
    _textController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showEmojiPicker = false;
          images.clear();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submitMessage() async {
    final text = _textController.text.trim();
    final notifier = ref.read(chatProvider(widget.roomId).notifier);

    List<String> uploadedImageUrls = [];
    if (images.isNotEmpty) {
      for (var file in images) {
        try {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
          final fileBytes = await file.readAsBytes();

          final response = await Supabase.instance.client.storage
              .from('message-images')
              .uploadBinary(
            fileName,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );
          final imageUrl = Supabase.instance.client.storage
              .from('message-images')
              .getPublicUrl(fileName);

          uploadedImageUrls.add(imageUrl);
        } catch (e) {
          print('Error uploading image: $e');
        }
      }

      /// Send messages with uploaded image URLs
      for (var url in uploadedImageUrls) {
        await notifier.sendMessage('', imageUrl: url);
      }

      /// Clear the images list after sending the messages
      setState(() {
        images.clear();
      });
    }

    /// Send a text message if the text is not empty
    if (text.isNotEmpty) {
      await notifier.sendMessage(text);
      _textController.clear();
    }
  }



  void _toggleEmojiPicker() {
    images.clear();
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });

    if (_showEmojiPicker) {
      FocusScope.of(context).unfocus();
    }
    else{
      FocusScope.of(context).requestFocus(_focusNode);
    }
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
            Divider(color: Colors.black12, height: 5),

            /// -- Image Previews --
            if (images.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (_, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                images.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black45,
                              ),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            /// -- Message Input Row --
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _showEmojiPicker
                        ? Icons.keyboard
                        : Icons.emoji_emotions_outlined,
                    color: Colors.black26,
                  ),
                  onPressed: _toggleEmojiPicker,
                ),
                IconButton(
                  icon: const Icon(Icons.photo, color: Colors.black26),
                  onPressed: () async {
                    _textController.clear();
                    FocusScope.of(context).unfocus();
                    final picker = ImagePicker();
                    final List<XFile>? imageFiles =
                    await picker.pickMultiImage();

                    if (imageFiles != null && imageFiles.isNotEmpty) {
                      setState(() {
                        images.addAll(imageFiles.map((e) => File(e.path)));
                        _showEmojiPicker = false;
                      });
                    }
                  },
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    autofocus: false,
                    focusNode: _focusNode,
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: kMarginMedium2,
                          vertical: kMarginMedium2),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _submitMessage,
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.black26,
                    size: 30,
                  ),
                ),
              ],
            ),

            /// -- Emoji Picker --
            if (_showEmojiPicker)
              EmojiPicker(
                textEditingController: _textController,
                config: Config(
                  height: 256,
                  checkPlatformCompatibility: true,
                  viewOrderConfig: const ViewOrderConfig(
                    top: EmojiPickerItem.searchBar,
                    middle: EmojiPickerItem.emojiView,
                    bottom: EmojiPickerItem.categoryBar,
                  ),
                  emojiViewConfig: const EmojiViewConfig(
                    backgroundColor: Colors.white,
                  ),
                  skinToneConfig: const SkinToneConfig(),
                  bottomActionBarConfig: const BottomActionBarConfig(
                    backgroundColor: Colors.white,
                    buttonColor: Colors.white,
                    buttonIconColor: Colors.black26,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

///chat bubble
class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.otherProfileImage,
    required this.profileImage,
  }) : super(key: key);

  final Message message;
  final String otherProfileImage;
  final String profileImage;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      /// User avatar
      UserAvatar(
        userId: message.profileId,
        fromChat: true,
        profileImage: message.isMine ? profileImage : otherProfileImage,
      ),
      const SizedBox(width: 12),

      /// Message container
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: message.isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                /// Main message bubble container
                CustomPaint(
                  painter: CustomStyleArrow(
                    isMine: message.isMine,
                    bubbleColor: message.isMine ? primaryColor : Colors.white,
                  ),
                  child: Container(
                    // Constrain the width of the container to avoid overflow
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75, // limit width to 75% of screen
                    ),
                    margin: EdgeInsets.only(left: message.isMine ? 0 : 10, right: message.isMine ? 10 : 0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.imageUrl != null && message.imageUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              message.imageUrl!,
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        if (message.content.isNotEmpty) ...[
                          if (message.imageUrl != null && message.imageUrl!.isNotEmpty)
                            const SizedBox(height: 8),
                          Text(
                            message.content,
                            style: TextStyle(
                              fontSize: 16,
                              color: message.isMine ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Time of the message
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              format(message.createdAt, locale: 'en_short'),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: message.isMine ? TextAlign.right : TextAlign.left,
            ),
          ),
        ],
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




