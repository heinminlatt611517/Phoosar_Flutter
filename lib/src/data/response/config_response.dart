class ConfigResponse {
  int? status;
  String? message;
  ConfigData? data;

  ConfigResponse({this.status, this.message, this.data});

  ConfigResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ConfigData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class ConfigData {
  int? skipQuestion;
  double? appVersion;
  double? releaseVersion;
  int? forceUpdate;

  ConfigData(
      {this.skipQuestion,
        this.appVersion,
        this.releaseVersion,
        this.forceUpdate});

  ConfigData.fromJson(Map<String, dynamic> json) {
    skipQuestion = json['skip_question'];
    appVersion = json['app_version'];
    releaseVersion = json['release_version'];
    forceUpdate = json['force_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skip_question'] = this.skipQuestion;
    data['app_version'] = this.appVersion;
    data['release_version'] = this.releaseVersion;
    data['force_update'] = this.forceUpdate;
    return data;
  }
}
