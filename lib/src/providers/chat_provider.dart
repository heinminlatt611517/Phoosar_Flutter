import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/models/message.dart';
import 'package:phoosar/src/features/chat/models/room.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';

final chatProvider = StateNotifierProvider.family<
    ChatNotifier,
    AsyncValue<List<Message>>,
    String>((ref, roomId) => ChatNotifier(ref, roomId));

class ChatNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  final Ref _ref;
  final String _roomId;
  StreamSubscription<List<Message>>? _messagesSubscription;
  late final _signalingSubscription;

  ChatNotifier(this._ref, this._roomId) : super(const AsyncValue.loading()) {
    _setMessagesListener();
    _setSignalingListener();
  }

  void _setMessagesListener() {
    final client = _ref.read(supabaseClientProvider);
    _messagesSubscription = client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', _roomId)
        .order('created_at', ascending: false)
        .map<List<Message>>(
          (data) => data
          .map<Message>((row) => Message.fromMap(
          map: row, myUserId: client.auth.currentUser!.id))
          .toList(),
    )
        .listen(
          (messages) {
        if (messages.isEmpty) {
          state = const AsyncValue.data([]);
        } else {
          state = AsyncValue.data(messages);
        }
      },
      onError: (error) =>
      state = AsyncValue.error(error, StackTrace.current),
    );
  }

  /// Increment unread count when a message is sent

  bool _isUserInChatScreen = false;

  Future<void> sendMessage(String content, {String? imageUrl}) async {
    final client = _ref.read(supabaseClientProvider);

    // Create the message, setting the imageUrl if it's provided
    final message = Message(
      id: 'temp',
      roomId: _roomId,
      profileId: client.auth.currentUser!.id,
      content: content,
      imageUrl: imageUrl, // Add imageUrl to the message if it's provided
      createdAt: DateTime.now(),
      isMine: true,
      isRead: false,
    );

    // Add the message to the state immediately
    state.whenData((messages) {
      state = AsyncValue.data([message, ...messages]);
    });

    try {
      // Insert the message into the database
      final response = await client.from('messages').insert(message.toMap()).select().single();

      // Update the unread count for the room
      final room = await client.from('rooms').select('unread_count').eq('id', _roomId).single();
      final currentUnreadCount = room['unread_count'] ?? 0;
      debugPrint("CurrentUnreadCount: $currentUnreadCount");

      if (message.profileId != client.auth.currentUser!.id) {
        if (!_isUserInChatScreen) {
          final newUnreadCount = currentUnreadCount + 1;
          debugPrint("NewUnreadCount: $newUnreadCount");

          // Update the unread count for the room
          await client.from('rooms').update({
            'unread_count': newUnreadCount,
          }).eq('id', _roomId);
        }
      }

      // Update the state with the real message ID once it is inserted into the database
      state.whenData((messages) {
        state = AsyncValue.data(
          messages.map((msg) {
            return msg.id == 'temp'
                ? msg.copyWith(id: response['id'], isRead: false)
                : msg;
          }).toList(),
        );
      });
    } catch (e) {
      // If the message insertion fails, remove the temporary message and log the error
      state.whenData((messages) {
        state = AsyncValue.data(messages.where((m) => m.id != 'temp').toList());
      });
      print("Error sending message: $e");
    }
  }

  void onEnterChatScreen() {
    _isUserInChatScreen = true;
  }

  void onLeaveChatScreen() {
    _isUserInChatScreen = false;
  }


  /// Reset unread count and mark all messages as read when the room is marked as read
  Future<void> markRoomAsRead() async {
    final client = _ref.read(supabaseClientProvider);
    final currentUserId = client.auth.currentUser!.id;

    debugPrint("RoomId>>>>>$_roomId");
    try {
      /// Reset the unread count to 0
      await client.from('rooms').update({'unread_count': 0}).eq('id', _roomId);

      /// Mark all messages in the room as read for the current user
      await markMessagesAsRead(currentUserId);

      /// Update the local state
      _ref.read(roomsProvider.notifier).state.whenData((rooms) {
        final index = rooms.indexWhere((room) => room.id == _roomId);
        if (index != -1) {
          rooms[index] = rooms[index].copyWith(
            unreadCount: 0,
          );
          _ref.read(roomsProvider.notifier).state = AsyncValue.data(List.from(rooms));
        }
      });
    } catch (e) {
      print("Error resetting unread count: $e");
    }
  }

  /// Mark messages as read when the room is marked as read
  Future<void> markMessagesAsRead(String currentUserId) async {
    final client = _ref.read(supabaseClientProvider);

    try {
      /// Mark messages as read for the current user in the specific room
      await client.from('messages')
          .update({'is_read': true})
          .eq('room_id', _roomId)
          .eq('profile_id', currentUserId)
          .eq('is_read', false);


      state.whenData((messages) {
        state = AsyncValue.data(
          messages.map((message) {
            return message.copyWith(isRead: true);
          }).toList(),
        );
      });
    } catch (e) {
      print("Error marking all messages as read: $e");
    }
  }


  /// Delete all messages in the room
  Future<void> deleteAllMessages() async {
    final client = _ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser!.id;

    try {
      await client.from('messages').delete().eq('room_id', _roomId);
      state = const AsyncValue.data([]);
    } catch (e, stackTrace) {
      print('Error deleting messages: $e');
      print('Stack trace: $stackTrace');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Delete the entire room
  Future<void> deleteRoom() async {
    final client = _ref.read(supabaseClientProvider);

    try {
      await client.from('rooms').delete().eq('id', _roomId);
      state = const AsyncValue.data([]);
    } catch (e, stackTrace) {
      print('Error deleting room: $e');
      print('Stack trace: $stackTrace');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Listen for signaling messages for video calls (newly added)
  void _setSignalingListener() {
    final client = _ref.read(supabaseClientProvider);
    _signalingSubscription = client
        .from('signaling_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', _roomId)
        .listen(
          (List<Map<String, dynamic>> data) {
        if (data.isNotEmpty) {
          final signal = data.last;

          final type = signal['type'];

          if (type == 'offer') {
            _handleOffer(signal['sdp'], signal['sender_id']);
          } else if (type == 'answer') {
            _handleAnswer(signal['sdp']);
          } else if (type == 'candidate') {
            _handleCandidate(signal['candidate']);
          }
        }
      },
    );
  }


  String _getReceiverId(String senderId) {
    final client = _ref.read(supabaseClientProvider);
    final currentUserId = client.auth.currentUser!.id;
    return currentUserId == senderId ? 'otherUserId' : currentUserId;
  }


  /// Send offer signaling message to the other user
  Future<void> sendOffer(String sdp) async {
    final client = _ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser!.id;
    final receiverId = _getReceiverId(userId);


    try {
      await client.from('signaling_messages').insert({
        'room_id': _roomId,
        'sender_id': userId,
        'receiver_id': receiverId,
        'type': 'offer',
        'sdp': sdp,
      }).select();
    } catch (e) {
      print('Error sending offer: $e');
    }
  }

  /// Send answer signaling message to the other user
  Future<void> sendAnswer(String sdp) async {
    final client = _ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser!.id;

    final receiverId = _getReceiverId(userId);

    try {
      await client.from('signaling_messages').insert({
        'room_id': _roomId,
        'sender_id': userId,
        'receiver_id': receiverId,
        'type': 'answer',
        'sdp': sdp,
      }).select();
    } catch (e) {
      print('Error sending answer: $e');
    }
  }

  /// Send ICE candidate signaling message to the other user
  Future<void> sendCandidate(Map<String, dynamic> candidate) async {
    final client = _ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser!.id;
    final receiverId = _getReceiverId(userId);

    try {
      await client.from('signaling_messages').insert({
        'room_id': _roomId,
        'sender_id': userId,
        'receiver_id': receiverId,
        'type': 'candidate',
        'candidate': candidate,
      }).select();
    } catch (e) {
      print('Error sending ICE candidate: $e');
    }
  }

  /// Handle incoming offer
  void _handleOffer(String sdp, String senderId) {
    // Here, you can handle the incoming offer by creating an offer and sending an answer
    print('Received offer: $sdp from $senderId');
    // Respond with an answer (use your RTC code for that)
  }

  /// Handle incoming answer
  void _handleAnswer(String sdp) {
    print('Received answer: $sdp');
    // Here, you can handle the answer (use your RTC code for that)
  }

  /// Handle incoming ICE candidate
  void _handleCandidate(Map<String, dynamic> candidate) {
    print('Received candidate: $candidate');
    // Add the candidate to your peer connection
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _signalingSubscription.cancel();
    super.dispose();
  }
}
