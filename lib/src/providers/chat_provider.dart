import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/models/message.dart';
import 'package:phoosar/src/providers/app_provider.dart';

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
          _incrementUnreadCountIfNeeded(messages);
        }
      },
      onError: (error) =>
      state = AsyncValue.error(error, StackTrace.current),
    );
  }

  /// Increment unread count if the user hasn't read the message yet
  void _incrementUnreadCountIfNeeded(List<Message> messages) {

    final client = _ref.read(supabaseClientProvider);
    final currentUserId = client.auth.currentUser!.id;

    final unreadMessages = messages.where((msg) => msg.profileId != currentUserId).toList();

    if (unreadMessages.isNotEmpty) {
      debugPrint("IncreaseUnreadCount");
      _updateUnreadCount(1);
    }
  }

  Future<void> _updateUnreadCount(int increment) async {
    final client = _ref.read(supabaseClientProvider);

    try {
      final roomData = await client.from('rooms').select('unread_count').eq('id', _roomId).single();
      final currentUnreadCount = roomData['unread_count'] ?? 0;
      final newUnreadCount = currentUnreadCount + increment;
      await client.from('rooms').update({'unread_count': newUnreadCount}).eq('id', _roomId);
    } catch (e) {
      print("Error updating unread count: $e");
    }
  }

  Future<void> sendMessage(String content) async {
    final client = _ref.read(supabaseClientProvider);
    final message = Message(
      id: 'temp',
      roomId: _roomId,
      profileId: client.auth.currentUser!.id,
      content: content,
      createdAt: DateTime.now(),
      isMine: true,
    );

    state.whenData(
            (messages) => state = AsyncValue.data([message, ...messages]));

    try {
      await client.from('messages').insert(message.toMap());
    } catch (e) {
      state.whenData((messages) => state =
          AsyncValue.data(messages.where((m) => m.id != 'temp').toList()));
    }
  }

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

  Future<void> markRoomAsRead() async {
    final client = _ref.read(supabaseClientProvider);

    try {
      await client.from('rooms').update({'unread_count': 0}).eq('id', _roomId);
    } catch (e) {
      print("Error resetting unread count: $e");
    }
  }

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

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
