class PurchaseHistoryListResponse {
  int? status;
  String? message;
  List<PurchaseHistoryData>? data;

  PurchaseHistoryListResponse({this.status, this.message, this.data});

  PurchaseHistoryListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PurchaseHistoryData>[];
      json['data'].forEach((v) {
        data!.add(new PurchaseHistoryData.fromJson(v));
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

class PurchaseHistoryData {
  int? id;
  String? description;
  String? date;
  int? amount;
  String? status;

  PurchaseHistoryData(
      {this.id, this.description, this.date, this.amount, this.status});

  PurchaseHistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    date = json['date'];
    amount = json['amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['date'] = this.date;
    data['amount'] = this.amount;
    data['status'] = this.status;
    return data;
  }
}
