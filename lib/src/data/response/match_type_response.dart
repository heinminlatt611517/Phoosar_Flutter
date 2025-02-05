class MatchTypeResponse {
  int? status;
  String? message;
  List<MatchTypeData>? data;

  MatchTypeResponse({this.status, this.message, this.data});

  MatchTypeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MatchTypeData>[];
      json['data'].forEach((v) {
        data!.add(new MatchTypeData.fromJson(v));
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

class MatchTypeData {
  String? label;
  String? value;

  MatchTypeData({this.label, this.value});

  MatchTypeData.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}