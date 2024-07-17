class AuthResponse {
  int? status;
  String? message;
  String? token;
  String? type;

  AuthResponse({this.status, this.message, this.token, this.type});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    data['type'] = this.type;
    return data;
  }
}
