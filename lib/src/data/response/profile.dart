class ProfileData {
  int? id;
  String? profileId;
  String? name;
  String? email;
  String? phone;
  int? isOnline;
  int? gender;
  dynamic birthdate;
  String? about;
  String? jobTitle;
  String? school;
  int? smoke;
  String? country;
  String? city;
  String? matchCountry;
  String? matchCity;
  List<String>? speakLanguages;
  List<String>? interests;
  List<MoreDetails>? moreDetails;
  List<String>? profileImages;

  ProfileData(
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
      this.profileImages});

  ProfileData.fromJson(Map<String, dynamic> json) {
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
    if (json['more_details'] != null) {
      moreDetails = <MoreDetails>[];
      json['more_details'].forEach((v) {
        moreDetails!.add(new MoreDetails.fromJson(v));
      });
    }
    profileImages = json['profile_images'].cast<String>();
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
    if (this.moreDetails != null) {
      data['more_details'] = this.moreDetails!.map((v) => v.toJson()).toList();
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
