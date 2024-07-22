class ProfileSaveRequest {
  String? name;
  String? gender;
  String? birthdate;
  String? about;
  String? jobTitle;
  String? school;
  String? livingIn;
  bool? smoke;
  String? country;
  String? city;
  String? matchCountry;
  String? matchCity;
  List<String>? profileImages;

  ProfileSaveRequest(
      {this.name,
      this.gender,
      this.birthdate,
      this.about,
      this.jobTitle,
      this.school,
      this.livingIn,
      this.smoke,
      this.country,
      this.city,
      this.matchCountry,
      this.matchCity,
      this.profileImages});

  ProfileSaveRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    birthdate = json['birthdate'];
    about = json['about'];
    jobTitle = json['job_title'];
    school = json['school'];
    livingIn = json['living_in'];
    smoke = json['smoke'];
    country = json['country'];
    city = json['city'];
    matchCountry = json['match_country'];
    matchCity = json['match_city'];
    profileImages = json['profile_images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['birthdate'] = this.birthdate;
    data['about'] = this.about;
    data['job_title'] = this.jobTitle;
    data['school'] = this.school;
    data['living_in'] = this.livingIn;
    data['smoke'] = this.smoke;
    data['country'] = this.country;
    data['city'] = this.city;
    data['match_country'] = this.matchCountry;
    data['match_city'] = this.matchCity;
    data['profile_images'] = this.profileImages;
    return data;
  }
}
