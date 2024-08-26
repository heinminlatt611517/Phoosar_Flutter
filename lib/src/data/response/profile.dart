class ProfileData {
  int? id;
  String? profileId;
  String? supabaseUserId;
  String? name;
  String? email;
  String? phone;
  int? isOnline;
  bool? isPremium;
  int? gender;
  dynamic birthdate;
  String? about;
  String? jobTitle;
  String? school;
  String? smoke;
  String? country;
  String? city;
  String? matchCountry;
  String? matchCity;
  int? score;
  List<String>? speakLanguages;
  List<String>? interests;
  List<MoreDetails>? moreDetails;
  List<String>? profileImages;
  List<UploadPhotoData>? uploadPhotoData;
  ShowAge? showAge;
  DistanceInvisible? distanceInvisible;

  ProfileData(
      {this.id,
      this.profileId,
      this.supabaseUserId,
      this.name,
      this.email,
      this.phone,
      this.isOnline,
      this.isPremium,
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
      this.score,
      this.speakLanguages,
      this.interests,
      this.moreDetails,
      this.profileImages,
      this.uploadPhotoData,
        this.showAge,
        this.distanceInvisible});

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileId = json['profile_id'];
    supabaseUserId = json['supabase_user_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    isOnline = json['is_online'];
    isPremium = json['is_premium'];
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
    score = json['score'];
    speakLanguages = json['speak_languages'].cast<String>();
    interests = json['interests'].cast<String>();
    if (json['more_details'] != null) {
      moreDetails = <MoreDetails>[];
      json['more_details'].forEach((v) {
        moreDetails!.add(new MoreDetails.fromJson(v));
      });
    }
    if (json['uploadPhotoData'] != null) {
      uploadPhotoData = <UploadPhotoData>[];
      json['uploadPhotoData'].forEach((v) {
        uploadPhotoData!.add(new UploadPhotoData.fromJson(v));
      });
    }
    profileImages = json['profile_images'].cast<String>();
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
    data['supbase_user_id'] = this.supabaseUserId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['is_online'] = this.isOnline;
    data['is_premium'] = this.isPremium;
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
    data['score'] = this.score;
    data['speak_languages'] = this.speakLanguages;
    data['interests'] = this.interests;
    if (this.moreDetails != null) {
      data['more_details'] = this.moreDetails!.map((v) => v.toJson()).toList();
    }
    if (this.uploadPhotoData != null) {
      data['uploadPhotoData'] =
          this.uploadPhotoData!.map((v) => v.toJson()).toList();
    }
    data['profile_images'] = this.profileImages;
    if (this.showAge != null) {
      data['show_age'] = this.showAge!.toJson();
    }
    if (this.distanceInvisible != null) {
      data['distance_invisible'] = this.distanceInvisible!.toJson();
    }
    return data;
  }
}

class MoreDetails {
  int? id;
  String? question;
  String? answerText;

  MoreDetails({this.id, this.question, this.answerText});

  MoreDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answerText = json['answer_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer_text'] = this.answerText;
    return data;
  }
}

class UploadPhotoData {
  String? id;
  String? url;
  bool? canUpload;

  UploadPhotoData({this.id, this.url, this.canUpload});

  UploadPhotoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    canUpload = json['can_upload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['can_upload'] = this.canUpload;
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
