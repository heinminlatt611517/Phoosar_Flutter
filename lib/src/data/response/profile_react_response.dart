import 'package:phoosar/src/data/response/profile.dart';

class ProfileReactResponse {
  int? status;
  String? message;
  ProfileReactData? data;

  ProfileReactResponse({this.status, this.message, this.data});

  ProfileReactResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new ProfileReactData.fromJson(json['data'])
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

class ProfileReactData {
  ProfileData? rewindData;
  ProfileData? matchData;

  ProfileReactData({this.rewindData, this.matchData});

  ProfileReactData.fromJson(Map<String, dynamic> json) {
    rewindData = json['rewind_data'] != null
        ? new ProfileData.fromJson(json['rewind_data'])
        : null;
    matchData = json['match_data'] != null
        ? new ProfileData.fromJson(json['match_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rewindData != null) {
      data['rewind_data'] = this.rewindData!.toJson();
    }
    if (this.matchData != null) {
      data['match_data'] = this.matchData!.toJson();
    }
    return data;
  }
}
