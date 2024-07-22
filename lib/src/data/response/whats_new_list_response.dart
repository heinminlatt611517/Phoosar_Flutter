class WhatsNewListResponse {
  int? status;
  String? message;
  List<WhatsNewData>? data;

  WhatsNewListResponse({this.status, this.message, this.data});

  WhatsNewListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WhatsNewData>[];
      json['data'].forEach((v) {
        data!.add(new WhatsNewData.fromJson(v));
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

class WhatsNewData {
  int? id;
  String? titleEn;
  String? titleBu;

  WhatsNewData({this.id, this.titleEn, this.titleBu});

  WhatsNewData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleEn = json['title_en'];
    titleBu = json['title_bu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title_en'] = this.titleEn;
    data['title_bu'] = this.titleBu;
    return data;
  }
}
