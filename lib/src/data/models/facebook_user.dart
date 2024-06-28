class FacebookUser {
  final String email;
  final String id;
  final String pictureUrl;
  final String name;

  FacebookUser({required this.email, required this.id, required this.pictureUrl, required this.name});

  factory FacebookUser.fromJson(Map<String, dynamic> json) {
    return FacebookUser(
      email: json['email'],
      id: json['id'],
      pictureUrl: json['picture']['data']['url'],
      name: json['name'],
    );
  }
}