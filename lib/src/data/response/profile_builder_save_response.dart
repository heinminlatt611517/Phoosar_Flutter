class ProfileBuilderSaveResponse {
  int? status;
  String? message;
  ProfileBuilderSaveData? data;

  ProfileBuilderSaveResponse({this.status, this.message, this.data});

  ProfileBuilderSaveResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new ProfileBuilderSaveData.fromJson(json['data'])
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

class ProfileBuilderSaveData {
  int? questionBuilderPoint;

  ProfileBuilderSaveData({this.questionBuilderPoint});

  ProfileBuilderSaveData.fromJson(Map<String, dynamic> json) {
    questionBuilderPoint = json['question_builder_point'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_builder_point'] = this.questionBuilderPoint;
    return data;
  }
}
