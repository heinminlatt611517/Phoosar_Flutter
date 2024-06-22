import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/models/message.dart';
import 'package:phoosar/src/features/chat/models/profile.dart';
import 'package:phoosar/src/features/chat/models/room.dart';
import 'package:phoosar/src/providers/app_provider.dart';

final roomsProvider =
    StateNotifierProvider<RoomsNotifier, AsyncValue<List<Room>>>(
        (ref) => RoomsNotifier(ref));

class RoomsNotifier extends StateNotifier<AsyncValue<List<Room>>> {
  final Ref _ref;
  late final String _myUserId;
  StreamSubscription<List<Map<String, dynamic>>>? _roomsSubscription;
  final Map<String, StreamSubscription<Message?>> _messageSubscriptions = {};

  RoomsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _initializeRooms();
  }

  Future<void> _initializeRooms() async {
    final client = _ref.read(supabaseClientProvider);
    _myUserId = client.auth.currentUser!.id; // Correctly accessing the user ID

    try {
      _roomsSubscription = client.from('room_participants').stream(
        primaryKey: ['room_id', 'profile_id'],
      ).listen(
        (participantMaps) {
          if (participantMaps.isEmpty) {
            state = const AsyncValue.data([]);
            return;
          }
          final rooms = participantMaps
              .map(Room.fromRoomParticipants)
              .where((room) => room.otherUserId != _myUserId)
              .toList();

          // Call _getNewestMessage for each room
          for (var room in rooms) {
            _getNewestMessage(room.id);
          }

          state = AsyncValue.data(rooms);
        },
        onError: (error) =>
            state = AsyncValue.error('Error loading rooms', StackTrace.current),
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  void _getNewestMessage(String roomId) {
    final client = _ref.read(supabaseClientProvider);
    _messageSubscriptions[roomId] = client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
        .limit(1)
        .map<Message?>(
          (data) => data.isEmpty
              ? null
              : Message.fromMap(map: data.first, myUserId: _myUserId),
        )
        .listen((message) {
          if (message != null) {
            state.whenData((rooms) {
              final index = rooms.indexWhere((room) => room.id == roomId);
              if (index != -1) {
                rooms[index] = rooms[index].copyWith(lastMessage: message);
                state = AsyncValue.data(
                    List.from(rooms)); // Create a new list to trigger UI update
              }
            });
          }
        });
  }

  Future<String> createRoom(String otherUserId) async {
    final client = _ref.read(supabaseClientProvider);
    final response = await client
        .rpc('create_new_room', params: {'other_user_id': otherUserId});
    if (response.error != null) {
      throw Exception('Failed to create room');
    }
    return response.data;
  }

  @override
  void dispose() {
    _roomsSubscription?.cancel();
    super.dispose();
  }
}
