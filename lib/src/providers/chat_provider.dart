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

  ChatNotifier(this._ref, this._roomId) : super(const AsyncValue.loading()) {
    _setMessagesListener();
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

  Future<void> markMessageAsRead(String messageId) async {
    final client = _ref.read(supabaseClientProvider);

    try {
      await client.from('messages').update({
        'is_read': true,
      }).eq('id', messageId);

      state.whenData((messages) {
        state = AsyncValue.data(
          messages.map((message) {
            return message.id == messageId
                ? message.copyWith(isRead: true)
                : message;
          }).toList(),
        );
      });
    } catch (e) {
      print('Error updating message read status: $e');
    }
  }

  /// Increment unread count when a message is sent
  Future<void> sendMessage(String content) async {
    final client = _ref.read(supabaseClientProvider);
    final message = Message(
      id: 'temp',
      roomId: _roomId,
      profileId: client.auth.currentUser!.id,
      content: content,
      createdAt: DateTime.now(),
      isMine: true,
      isRead: false,
    );

    state.whenData((messages) => state = AsyncValue.data([message, ...messages]));

    try {
      final response = await client.from('messages').insert(message.toMap()).select().single();

      final room = await client.from('rooms').select('unread_count').eq('id', _roomId).single();
      final newUnreadCount = (room['unread_count'] ?? 0) + 1;

      debugPrint("RoomId>>>>>$_roomId");

      await client.from('rooms').update({
        'unread_count': newUnreadCount,
      }).eq('id', _roomId);


      state.whenData((messages) {
        state = AsyncValue.data(
          messages.map((msg) {
            return msg.id == 'temp'
                ? msg.copyWith(id: response['id'], isRead: false)  // Set real message ID
                : msg;
          }).toList(),
        );
      });
    } catch (e) {
      state.whenData((messages) {
        state = AsyncValue.data(messages.where((m) => m.id != 'temp').toList());
      });
      print("Error sending message: $e");
    }
  }


  /// Reset unread count and mark all messages as read when the room is marked as read
  Future<void> markRoomAsRead() async {
    final client = _ref.read(supabaseClientProvider);

    try {
      await client.from('rooms').update({'unread_count': 0}).eq('id', _roomId);

      await markMessagesAsRead();

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

  Future<void> markMessagesAsRead() async {
    final client = _ref.read(supabaseClientProvider);

    try {
      await client.from('messages').update({
        'is_read': true,
      }).eq('room_id', _roomId);

      /// Update the local state
      state.whenData((messages) {
        state = AsyncValue.data(
          messages.map((message) => message.copyWith(isRead: true)).toList(),
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

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
