class ForgotPasswordRequest {
  String? type;
  String? value;

  ForgotPasswordRequest({this.type, this.value});

  ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}
