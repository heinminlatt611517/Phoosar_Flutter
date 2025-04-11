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
  final Map<String, StreamSubscription<int>> _unreadCountSubscriptions = {};

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


      _messageSubscriptions.forEach((_, sub) => sub.cancel());
      _messageSubscriptions.clear();
      _unreadCountSubscriptions.forEach((_, sub) => sub.cancel());
      _unreadCountSubscriptions.clear();

      for (final room in _rooms) {
      _getNewestMessage(room.id);
      _subscribeToUnreadCount(room.id);
      }
      state = AsyncValue.data(_rooms);
      }, onError: (error) {
      throw ('Error loading rooms');
    });
  }

  void _subscribeToUnreadCount(String roomId) {
    final client = _ref.read(supabaseClientProvider);
    _unreadCountSubscriptions[roomId] = client
        .from('room_participants')
        .stream(primaryKey: ['room_id', 'profile_id'])
        .eq('room_id', roomId)
        .map<int>((data) {

      final participant = data.firstWhere(
            (row) => row['profile_id'] == _myUserId,
      );
      return participant['unread_count'] as int;
        })
        .listen((unreadCount) {

          debugPrint("UnreadCount>>>>>>>$unreadCount");

      state.whenData((rooms) {
        final index = rooms.indexWhere((room) => room.id == roomId);
        if (index != -1) {
          rooms[index] = rooms[index].copyWith(unreadCount: unreadCount);
          state = AsyncValue.data(List.from(rooms));
        }
      });
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
        state.whenData((rooms) {
          final index = rooms.indexWhere((room) => room.id == roomId);
          if (index != -1) {
            rooms[index] = rooms[index].copyWith(lastMessage: message);
            state = AsyncValue.data(List.from(rooms));
          }
        });
      }
    });
  }

  Future<void> markMessagesAsRead(String roomId) async {
    final client = _ref.read(supabaseClientProvider);
    await client
        .from('room_participants')
        .update({'unread_count': 0})
        .eq('room_id', roomId)
        .eq('profile_id', _myUserId);
  }

  Future<String> createRoom(String otherUserId) async {
    final client = _ref.read(supabaseClientProvider);
    log("Creating room with user ID: $otherUserId");
    final response = await client
        .rpc('create_new_room', params: {'other_user_id': otherUserId});
    return response.toString();
  }

  Future<void> deleteRoom(String roomId) async {
    final client = _ref.read(supabaseClientProvider);

    try {
      final response = await client.from('rooms').delete().eq('id', roomId);

      if (response.error != null) {
        throw response.error!;
      }


      state.whenData((rooms) {

        final updatedRooms = rooms.where((room) => room.id != roomId).toList();
        state = AsyncValue.data(updatedRooms);
      });

      _messageSubscriptions[roomId]?.cancel();
      _unreadCountSubscriptions[roomId]?.cancel();
      _messageSubscriptions.remove(roomId);
      _unreadCountSubscriptions.remove(roomId);

    } catch (e, stackTrace) {
      debugPrint('Error deleting room: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }


  @override
  void dispose() {
    _roomsSubscription?.cancel();
    _messageSubscriptions.forEach((_, sub) => sub.cancel());
    _unreadCountSubscriptions.forEach((_, sub) => sub.cancel());
    super.dispose();
  }
}