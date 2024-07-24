class RewindListResponse {
  int? status;
  String? message;
  List<RewindData>? data;

  RewindListResponse({this.status, this.message, this.data});

  RewindListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RewindData>[];
      json['data'].forEach((v) {
        data!.add(new RewindData.fromJson(v));
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

class RewindData {
  int? id;
  int? rewind;
  int? point;

  RewindData({this.id, this.rewind, this.point});

  RewindData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rewind = json['rewind'];
    point = json['point'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rewind'] = this.rewind;
    data['point'] = this.point;
    return data;
  }
}
