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
      'profile_url': profileUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'] ??
            'default_id', // Provide a default value or ensure the field is never null
        username = map['username'] ?? 'default_username',
        profileUrl = map['profile_url'] ?? 'default_url',
        createdAt = map['created_at'] != null
            ? DateTime.parse(map['created_at'])
            : DateTime.now(); // Provide a default DateTime if null

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
