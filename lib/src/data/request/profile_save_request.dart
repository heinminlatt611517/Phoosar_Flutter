class ProfileSaveRequest {
  String? name;
  String? gender;
  String? birthdate;
  String? about;
  String? jobTitle;
  String? school;
  bool? smoke;
  String? country;
  String? city;
  String? matchCountry;
  String? matchCity;
  List<String>? profileImages;
  List<String>? moreDetails;
  List<String>? interests;
  List<String>? speakLanguages;
  ProfileSaveRequest(
      {this.name,
      this.gender,
      this.birthdate,
      this.about,
      this.jobTitle,
      this.school,
      this.smoke = false,
      this.country,
      this.city,
      this.matchCountry,
      this.matchCity,
      this.profileImages,
      this.moreDetails,
      this.interests,
      this.speakLanguages});

  ProfileSaveRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
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
    profileImages = json['profile_images'].cast<String>();
    moreDetails = json['more_details'].cast<String>();
    interests = json['interests'].cast<String>();
    speakLanguages = json['speak_languages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
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
    data['profile_images'] = this.profileImages;
    data['more_details'] = this.moreDetails;
    data['interests'] = this.interests;
    data['speak_languages'] = this.speakLanguages;
    return data;
  }
}
