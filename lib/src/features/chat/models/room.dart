
import 'package:phoosar/src/features/chat/models/message.dart';

class Room {
  Room({
    required this.id,
    required this.createdAt,
    required this.otherUserId,
    this.lastMessage,
    this.unreadCount = 0,
  });

  /// ID of the room
  final String id;

  /// Date and time when the room was created
  final DateTime createdAt;

  /// ID of the user who the user is talking to
  final String otherUserId;

  /// Latest message submitted in the room
  final Message? lastMessage;

  final int unreadCount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'unreadCount': unreadCount,
    };
  }

  /// Creates a room object from room_participants table
  Room.fromRoomParticipants(Map<String, dynamic> map)
      : id = map['room_id'],
        otherUserId = map['profile_id'],
        createdAt = DateTime.parse(map['created_at']),
        unreadCount = map['unread_count'] ?? 0,
        lastMessage = null;

  Room copyWith({
    String? id,
    DateTime? createdAt,
    String? otherUserId,
    Message? lastMessage,
    int? unreadCount,
  }) {
    return Room(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      otherUserId: otherUserId ?? this.otherUserId,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
