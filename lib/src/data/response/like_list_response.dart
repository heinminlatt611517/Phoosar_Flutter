class LikeListResponse {
  int? status;
  String? message;
  List<LikeData>? data;

  LikeListResponse({this.status, this.message, this.data});

  LikeListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LikeData>[];
      json['data'].forEach((v) {
        data!.add(new LikeData.fromJson(v));
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

class LikeData {
  int? id;
  int? like;
  int? point;

  LikeData({this.id, this.like, this.point});

  LikeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    like = json['like'];
    point = json['point'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['like'] = this.like;
    data['point'] = this.point;
    return data;
  }
}
