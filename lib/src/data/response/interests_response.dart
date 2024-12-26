class InterestsResponse {
  int? status;
  List<InterestData>? data;

  InterestsResponse({this.status, this.data});

  InterestsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <InterestData>[];
      json['data'].forEach((v) {
        data!.add(new InterestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InterestData {
  int? id;
  String? title;
  List<String>? items;

  InterestData({this.id, this.title, this.items});

  InterestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    items = json['items'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['items'] = this.items;
    return data;
  }
}