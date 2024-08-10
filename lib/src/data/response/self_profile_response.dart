class SelfProfileResponse {
  int? status;
  String? message;
  SelfProfileData? data;
  GenderList? genderList;

  SelfProfileResponse({this.status, this.message, this.data, this.genderList});

  SelfProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SelfProfileData.fromJson(json['data']) : null;
    genderList = json['gender_list'] != null
        ? new GenderList.fromJson(json['gender_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.genderList != null) {
      data['gender_list'] = this.genderList!.toJson();
    }
    return data;
  }
}

class SelfProfileData {
  int? id;
  String? profileId;
  String? name;
  dynamic email;
  String? phone;
  int? isOnline;
  int? gender;
  String? birthdate;
  String? about;
  dynamic jobTitle;
  dynamic school;
  dynamic smoke;
  String? country;
  String? city;
  String? matchCountry;
  String? matchCity;
  List<String>? speakLanguages;
  List<String>? interests;
  List<String>? moreDetails;
  List<String>? profileImages;
  String? membershipExpire;
  int? pointTotal;
  int? likeTotal;
  int? rewindTotal;
  BuyProfileImage? buyProfileImage;
  ShowAge? showAge;
  DistanceInvisible? distanceInvisible;

  SelfProfileData(
      {this.id,
      this.profileId,
      this.name,
      this.email,
      this.phone,
      this.isOnline,
      this.gender,
      this.birthdate,
      this.about,
      this.jobTitle,
      this.school,
      this.smoke,
      this.country,
      this.city,
      this.matchCountry,
      this.matchCity,
      this.speakLanguages,
      this.interests,
      this.moreDetails,
      this.profileImages,
      this.membershipExpire,
      this.pointTotal,
      this.likeTotal,
      this.rewindTotal,
      this.buyProfileImage,
      this.showAge,
      this.distanceInvisible});

  SelfProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileId = json['profile_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    isOnline = json['is_online'];
    gender = json['gender'];
    birthdate = json['birthdate'];
    about = json['about'];
    jobTitle = json['job_title'];
    school = json['school'];
    smoke = json['smoke'];
    country = json['country'];
    city = json['city'];
    matchCountry = json['match_country'];
    matchCity = json['match_city'];
    speakLanguages = json['speak_languages'].cast<String>();
    interests = json['interests'].cast<String>();
    moreDetails = json['more_details'].cast<String>();
    profileImages = json['profile_images'].cast<String>();
    membershipExpire = json['membership_expire'];
    pointTotal = json['point_total'];
    likeTotal = json['like_total'];
    rewindTotal = json['rewind_total'];
    buyProfileImage = json['buy_profile_image'] != null
        ? new BuyProfileImage.fromJson(json['buy_profile_image'])
        : null;
    showAge = json['show_age'] != null
        ? new ShowAge.fromJson(json['show_age'])
        : null;
    distanceInvisible = json['distance_invisible'] != null
        ? new DistanceInvisible.fromJson(json['distance_invisible'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_id'] = this.profileId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['is_online'] = this.isOnline;
    data['gender'] = this.gender;
    data['birthdate'] = this.birthdate;
    data['about'] = this.about;
    data['job_title'] = this.jobTitle;
    data['school'] = this.school;
    data['smoke'] = this.smoke;
    data['country'] = this.country;
    data['city'] = this.city;
    data['match_country'] = this.matchCountry;
    data['match_city'] = this.matchCity;
    data['speak_languages'] = this.speakLanguages;
    data['interests'] = this.interests;
    data['more_details'] = this.moreDetails;
    data['profile_images'] = this.profileImages;
    data['membership_expire'] = this.membershipExpire;
    data['point_total'] = this.pointTotal;
    data['like_total'] = this.likeTotal;
    data['rewind_total'] = this.rewindTotal;
    if (this.buyProfileImage != null) {
      data['buy_profile_image'] = this.buyProfileImage!.toJson();
    }
    if (this.showAge != null) {
      data['show_age'] = this.showAge!.toJson();
    }
    if (this.distanceInvisible != null) {
      data['distance_invisible'] = this.distanceInvisible!.toJson();
    }
    return data;
  }
}

class BuyProfileImage {
  int? pointProfileImage;
  int? canUploadCount;

  BuyProfileImage({this.pointProfileImage, this.canUploadCount});

  BuyProfileImage.fromJson(Map<String, dynamic> json) {
    pointProfileImage = json['point_profile_image'];
    canUploadCount = json['can_upload_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['point_profile_image'] = this.pointProfileImage;
    data['can_upload_count'] = this.canUploadCount;
    return data;
  }
}

class ShowAge {
  bool? showAgeStatus;
  int? pointProfileShowAge;

  ShowAge({this.showAgeStatus, this.pointProfileShowAge});

  ShowAge.fromJson(Map<String, dynamic> json) {
    showAgeStatus = json['show_age_status'];
    pointProfileShowAge = json['point_profile_show_age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['show_age_status'] = this.showAgeStatus;
    data['point_profile_show_age'] = this.pointProfileShowAge;
    return data;
  }
}

class DistanceInvisible {
  bool? distanceInvisibleStatus;
  int? pointDistanceInvisible;

  DistanceInvisible(
      {this.distanceInvisibleStatus, this.pointDistanceInvisible});

  DistanceInvisible.fromJson(Map<String, dynamic> json) {
    distanceInvisibleStatus = json['distance_invisible_status'];
    pointDistanceInvisible = json['point_distance_invisible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance_invisible_status'] = this.distanceInvisibleStatus;
    data['point_distance_invisible'] = this.pointDistanceInvisible;
    return data;
  }
}

class GenderList {
  String? s1;
  String? s2;

  GenderList({this.s1, this.s2});

  GenderList.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    return data;
  }
}
