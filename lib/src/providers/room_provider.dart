import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/chat/models/message.dart';
import 'package:phoosar/src/features/chat/models/room.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/profile_provider.dart';
import 'package:phoosar/src/providers/profiles_provider.dart';

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
    _myUserId = client.auth.currentUser!.id;
    log("My user ID: $_myUserId");

    List<Room> _rooms = [];

    _ref.invalidate(profilesProvider);
    _ref.invalidate(profileProvider);

    _roomsSubscription = client.from('room_participants').stream(
      primaryKey: ['room_id', 'profile_id'],
    ).listen((participantMaps) async {
      if (participantMaps.isEmpty) {
        state = const AsyncValue.data([]);
        return;
      }

      _rooms = participantMaps
          .map(Room.fromRoomParticipants)
          .where((room) => room.otherUserId != _myUserId)
          .toList();

      for (final room in _rooms) {
        _getNewestMessage(room.id);
      }
      state = AsyncValue.data(_rooms);
    }, onError: (error) {
      throw ('Error loading rooms');
    });
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
        _updateRoomWithMessage(roomId, message);
      }
    });
  }

  void _updateRoomWithMessage(String roomId, Message message) {
    state.whenData((rooms) {
      final index = rooms.indexWhere((room) => room.id == roomId);
      if (index != -1) {
        rooms[index] = rooms[index].copyWith(lastMessage: message);

        if (message.profileId != _myUserId) {
          _incrementUnreadCount(roomId);
        }

        state = AsyncValue.data(List.from(rooms));
      }
    });
  }

  Future<void> _incrementUnreadCount(String roomId) async {
    try {
      final client = _ref.read(supabaseClientProvider);
      final response = await client
          .from('rooms')
          .update({'unread_count': 3})
          .eq('id', roomId);

      if (response.error != null) {
        print('Error updating unread count: ${response.error!.message}');
      } else {
        print('Unread count updated successfully');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }


  Future<String> createRoom(String otherUserId) async {
    final client = _ref.read(supabaseClientProvider);
    log("Creating room with user ID: $otherUserId");
    final response = await client
        .rpc('create_new_room', params: {'other_user_id': otherUserId});

    return response.toString();
  }

  @override
  void dispose() {
    _messageSubscriptions.forEach((_, subscription) => subscription.cancel());
    _roomsSubscription?.cancel();
    super.dispose();
  }
}
