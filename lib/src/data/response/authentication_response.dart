class AuthenticationResponse {
  int? status;
  String? message;
  String? token;
  String? type;
  String? recentOnBoarding;

  AuthenticationResponse(
      {this.status,
      this.message,
      this.token,
      this.type,
      this.recentOnBoarding});

  AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    type = json['type'];
    recentOnBoarding = json['recent_onboarding'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    data['type'] = this.type;
    data['recent_onboarding'] = this.recentOnBoarding;
    return data;
  }
}
