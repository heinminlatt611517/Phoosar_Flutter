class DefaultResponse {
  String? message;
  List<String>? errors;

  DefaultResponse({this.message, this.errors});

  DefaultResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errors = json['errors']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['message'] = this.message;
    data['errors'] = this.errors;

    return data;
  }
}
