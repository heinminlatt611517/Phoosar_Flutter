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
          .map<Message>((row) => Message.fromMap(map: row, myUserId: client.auth.currentUser!.id))
          .toList(),
    )
        .listen(
          (messages) {
        if (_isFirstLoad) {
          _ref.read(roomsProvider.notifier).markMessagesAsRead(_roomId);
          _isFirstLoad = false;
        }

        if (messages.isEmpty) {
          state = const AsyncValue.data([]);
        } else {
          state = AsyncValue.data(messages);
        }
      },
      onError: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> sendMessage(String content, {String? imageUrl}) async {
    final client = _ref.read(supabaseClientProvider);
    final message = Message(
      id: 'temp',
      roomId: _roomId,
      profileId: client.auth.currentUser!.id,
      content: content,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      isMine: true,
    );

    state.whenData((messages) => state = AsyncValue.data([message, ...messages]));
    try {
      await client.from('messages').insert(message.toMap());

      await client.rpc('increment_unread_count', params: {
        'p_room_id': _roomId,
        'p_sender_id': client.auth.currentUser!.id,
      });

    } catch (e) {
      state.whenData((messages) => state = AsyncValue.data(messages.where((m) => m.id != 'temp').toList()));
    }
  }

  void onChatScreenOpened() {
      _ref.read(roomsProvider.notifier).markMessagesAsRead(_roomId);
  }

  void onChatScreenClosed() {
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

  String _getReceiverId(String senderId) {
    final client = _ref.read(supabaseClientProvider);
    final currentUserId = client.auth.currentUser!.id;

    return currentUserId == senderId ? 'otherUserId' : currentUserId;
  }

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

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}