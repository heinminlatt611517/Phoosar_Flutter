class ProfileData {
  int? id;
  String? profileId;
  String? name;
  String? email;
  dynamic phone;
  int? isOnline;
  int? gender;
  dynamic birthdate;
  String? about;
  String? jobTitle;
  String? school;
  String? livingIn;
  int? smoke;
  String? country;
  String? city;
  String? matchCountry;
  String? matchCity;
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
      this.livingIn,
      this.smoke,
      this.country,
      this.city,
      this.matchCountry,
      this.matchCity,
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
