class Profile {
  Profile({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.profileUrl,
  });

  /// User ID of the profile
  final String id;

  /// Username of the profile
  final String username;
  final String profileUrl;

  /// Date and time when the profile was created
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        profileUrl = map['profile_url'],
        createdAt = DateTime.parse(map['created_at']);

  Profile copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? profileUrl,
  }) {
    return Profile(
      id: id ?? this.id,
      username: name ?? username,
      createdAt: createdAt ?? this.createdAt,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }
}
