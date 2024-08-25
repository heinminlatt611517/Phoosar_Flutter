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
  List<String>? speakLanguages;
  List<String>? interests;
  List<MoreDetails>? moreDetails;
  List<String>? profileImages;
  List<UploadPhotoData>? uploadPhotoData;

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
      this.speakLanguages,
      this.interests,
      this.moreDetails,
      this.profileImages,
      this.uploadPhotoData});

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
