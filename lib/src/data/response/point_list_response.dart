class PointListResponse {
  int? status;
  String? message;
  List<PointData>? data;

  PointListResponse({this.status, this.message, this.data});

  PointListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PointData>[];
      json['data'].forEach((v) {
        data!.add(new PointData.fromJson(v));
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

class PointData {
  int? id;
  String? name;
  String? value;
  String? point;

  PointData({this.id, this.name, this.value, this.point});

  PointData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    point = json['point'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['point'] = this.point;
    return data;
  }
}
