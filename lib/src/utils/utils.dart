class Utils {
  static String calculateAge(String birthdate) {
    if (birthdate.isEmpty) return '';
    DateTime birthDate = DateTime.parse(birthdate);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }
}