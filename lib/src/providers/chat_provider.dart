import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/models/message.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';

final chatProvider = StateNotifierProvider.family<ChatNotifier, AsyncValue<List<Message>>, String>(
        (ref, roomId) => ChatNotifier(ref, roomId)
);

class ChatNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  final Ref _ref;
  final String _roomId;
  StreamSubscription<List<Message>>? _messagesSubscription;
  bool _isFirstLoad = true;

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
        map: row,
        myUserId: client.auth.currentUser!.id,
      ))
          .toList(),
    )
        .listen(
          (messages) {
        if (_isFirstLoad) {
          _ref.read(roomsProvider.notifier).markMessagesAsRead(_roomId);
          _isFirstLoad = false;
        }

        state = AsyncValue.data(messages);
      },
      onError: (error) =>
      state = AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> sendMessage(String content, {String? imageUrl}) async {
    final client = _ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser!.id;

    final message = Message(
      id: 'temp',
      roomId: _roomId,
      profileId: userId,
      content: content,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      isMine: true,
    );

    state.whenData((messages) => state = AsyncValue.data([message, ...messages]));

    try {
      await client.from('messages').insert(message.toMap());

      final receiverId = await _getReceiverId();
      if (receiverId == null) {
        debugPrint('Receiver not found — skipping unread increment');
        return;
      }

      debugPrint("IsReceiverId → $receiverId");

      final isReceiverActive = await _checkUserActivityStatus(receiverId);
      debugPrint("IsReceiverActive → $isReceiverActive");

      if (!isReceiverActive) {
        await client.rpc('increment_unread_count', params: {
          'p_room_id': _roomId,
          'p_sender_id': userId,
        });
      }
    } catch (e) {
      state.whenData((messages) =>
      state = AsyncValue.data(messages.where((m) => m.id != 'temp').toList()));
      debugPrint('❌ Error sending message: $e');
    }
  }

  Future<String?> _getReceiverId() async {
    final client = _ref.read(supabaseClientProvider);
    final currentUserId = client.auth.currentUser!.id;

    final response = await client
        .from('room_participants')
        .select('profile_id')
        .eq('room_id', _roomId)
        .neq('profile_id', currentUserId)
        .maybeSingle();

    if (response == null) {
      debugPrint('❌ Could not find receiver ID');
      return null;
    }

    return response['profile_id'] as String;
  }

  Future<bool> _checkUserActivityStatus(String userId) async {
    final client = _ref.read(supabaseClientProvider);

    final response = await client
        .from('room_participants')
        .select('is_active_in_chat')
        .eq('room_id', _roomId)
        .eq('profile_id', userId)
        .maybeSingle();

    if (response == null) {
      debugPrint('No matching participant found');
      return false;
    }

    return response['is_active_in_chat'] ?? false;
  }

  void onChatScreenOpened() {
    _ref.read(roomsProvider.notifier).markMessagesAsRead(_roomId);
    _setUserActiveStatus(true);
  }

  void onChatScreenClosed() {
    _setUserActiveStatus(false);
  }

  Future<void> _setUserActiveStatus(bool isActive) async {
    final client = _ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser!.id;

    await client
        .from('room_participants')
        .update({'is_active_in_chat': isActive})
        .eq('room_id', _roomId)
        .eq('profile_id', userId);
  }

  Future<void> deleteAllMessages() async {
    final client = _ref.read(supabaseClientProvider);

    try {
      await client.from('messages').delete().eq('room_id', _roomId);
      state = const AsyncValue.data([]);
    } catch (e, stackTrace) {
      debugPrint('Error deleting messages: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteRoom() async {
    final client = _ref.read(supabaseClientProvider);

    try {
      await client.from('rooms').delete().eq('id', _roomId);
      state = const AsyncValue.data([]);
    } catch (e, stackTrace) {
      debugPrint('Error deleting room: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
