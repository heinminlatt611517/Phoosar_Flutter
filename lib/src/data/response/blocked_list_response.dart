import 'package:phoosar/src/data/response/profile.dart';

class BlockedListResponse {
  int? status;
  String? message;
  List<BlockUserData>? data;

  BlockedListResponse({this.status, this.message, this.data});

  BlockedListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BlockUserData>[];
      json['data'].forEach((v) {
        data!.add(new BlockUserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlockUserData {
  int? id;
  ProfileData? profile;
  int? mTime;
  int? fTime;
  int? mType;
  int? fType;
  String? createdAt;
  String? updatedAt;

  BlockUserData(
      {this.id,
      this.profile,
      this.mTime,
      this.fTime,
      this.mType,
      this.fType,
      this.createdAt,
      this.updatedAt});

  BlockUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profile = json['profile'] != null
        ? new ProfileData.fromJson(json['profile'])
        : null;
    mTime = json['m_time'];
    fTime = json['f_time'];
    mType = json['m_type'];
    fType = json['f_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    data['m_time'] = this.mTime;
    data['f_time'] = this.fTime;
    data['m_type'] = this.mType;
    data['f_type'] = this.fType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
