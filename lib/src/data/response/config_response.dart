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
  String? appVersion;
  String? releaseVersion;
  int? forceUpdate;
  int? percentage;
  int? showBuyCoin;
  int? skipCount;
  int? rewindCount;

  ConfigData(
      {this.skipQuestion,
        this.appVersion,
        this.releaseVersion,
        this.forceUpdate,
        this.percentage,
      this.showBuyCoin,
      this.skipCount,
      this.rewindCount});

  ConfigData.fromJson(Map<String, dynamic> json) {
    skipQuestion = json['skip_question'];
    appVersion = json['app_version'];
    releaseVersion = json['release_version'];
    forceUpdate = json['force_update'];
    percentage = json['percentage'];
    showBuyCoin = json['show_buy_coin'];
    skipCount = json['skip_count'];
    rewindCount = json['rewind_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skip_question'] = this.skipQuestion;
    data['app_version'] = this.appVersion;
    data['release_version'] = this.releaseVersion;
    data['force_update'] = this.forceUpdate;
    data['percentage'] = this.percentage;
    data['show_buy_coin'] = this.showBuyCoin;
    data['skip_count'] = this.skipCount;
    data['rewind_count'] = this.rewindCount;
    return data;
  }
}
