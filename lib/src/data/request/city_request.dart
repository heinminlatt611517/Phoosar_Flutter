class CityRequest {
  String? countryCode;

  CityRequest({this.countryCode});

  CityRequest.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_code'] = this.countryCode;
    return data;
  }
}
