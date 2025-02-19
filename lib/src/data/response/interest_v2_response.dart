class InterestV2Response {
  int? status;
  List<String>? data;

  InterestV2Response({this.status, this.data});

  InterestV2Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}