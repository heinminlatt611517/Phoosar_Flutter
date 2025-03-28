class BackgroundVideoResponse {
  int? status;
  BackgroundVideoData? data;

  BackgroundVideoResponse({this.status, this.data});

  BackgroundVideoResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new BackgroundVideoData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BackgroundVideoData {
  String? videoUrl;

  BackgroundVideoData({this.videoUrl});

  BackgroundVideoData.fromJson(Map<String, dynamic> json) {
    videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_url'] = this.videoUrl;
    return data;
  }
}