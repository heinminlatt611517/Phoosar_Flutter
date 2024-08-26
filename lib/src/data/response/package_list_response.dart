class PackageListResponse {
  int? status;
  String? message;
  List<PackageData>? data;

  PackageListResponse({this.status, this.message, this.data});

  PackageListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PackageData>[];
      json['data'].forEach((v) {
        data!.add(new PackageData.fromJson(v));
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

class PackageData {
  int? id;
  String? name;
  int? month;
  String? value;
  bool? isPopular;

  PackageData({this.id, this.name, this.month, this.value, this.isPopular});

  PackageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    month = json['month'];
    value = json['value'];
    isPopular = json['is_popular'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['month'] = this.month;
    data['value'] = this.value;
    data['is_popular'] = this.isPopular;
    return data;
  }
}
