class ProfileBuilderResponse {
  int? status;
  String? message;
  ProfileBuilderData? data;

  ProfileBuilderResponse({this.status, this.message, this.data});

  ProfileBuilderResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new ProfileBuilderData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProfileBuilderData {
  int? id;
  String? question;
  String? answerText;
  String? paidStatus;

  ProfileBuilderData(
      {this.id, this.question, this.answerText, this.paidStatus});

  ProfileBuilderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answerText = json['answer_text'];
    paidStatus = json['paid_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer_text'] = this.answerText;
    data['paid_status'] = this.paidStatus;
    return data;
  }
}
