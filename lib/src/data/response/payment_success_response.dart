class PaymentSuccessResponse {
  int? status;
  String? message;
  PaymentSuccessData? data;

  PaymentSuccessResponse({this.status, this.message, this.data});

  PaymentSuccessResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new PaymentSuccessData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PaymentSuccessData {
  String? paymentUrl;
  String? qrCode;
  String? mimeType;

  PaymentSuccessData({this.paymentUrl, this.qrCode, this.mimeType});

  PaymentSuccessData.fromJson(Map<String, dynamic> json) {
    paymentUrl = json['payment_url'];
    qrCode = json['qr_code'];
    mimeType = json['mime_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_url'] = this.paymentUrl;
    data['qr_code'] = this.qrCode;
    data['mime_type'] = this.mimeType;
    return data;
  }
}
