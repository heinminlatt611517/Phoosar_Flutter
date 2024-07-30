class CountryListResponse {
  int? status;
  String? message;
  List<CountryData>? data;

  CountryListResponse({this.status, this.message, this.data});

  CountryListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CountryData>[];
      json['data'].forEach((v) {
        data!.add(new CountryData.fromJson(v));
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

class CountryData {
  int? code;
  String? name;

  CountryData({this.code, this.name});

  CountryData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
