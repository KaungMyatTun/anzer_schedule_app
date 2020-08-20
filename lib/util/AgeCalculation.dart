class AgeCalculation {

  // from date of birth to age
  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  // from age to date of birth
  calculateDoB(int age){
    DateTime currentDate = DateTime.now();
    int _dobYear = currentDate.year - age;

    String _dob = '01-01-$_dobYear';
    return _dob;
  }

}
