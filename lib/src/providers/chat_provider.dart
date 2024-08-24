import 'dart:async';
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
            }
          },
          onError: (error) =>
              state = AsyncValue.error(error, StackTrace.current),
        );
  }

  Future<void> sendMessage(String content) async {
    final client = _ref.read(supabaseClientProvider);
    final message = Message(
      id: 'temp', // Temporary ID until confirmed by the database
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

  Future<void> deleteAllMessages() async {
    final client = _ref.read(supabaseClientProvider);
    try {
      await client.from('messages').delete().eq('room_id', _roomId);
      state = const AsyncValue.data([]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
