class Note {
  String body;
  String title;
  DateTime dateModified;
  DateTime dateCreated;

  Note({required this.body, required this.dateCreated, required this.title, required this.dateModified});

  String get getDateModified {
    var weekDayName = getWeekDay(dateModified.weekday);
    var monthName = getMonthName(dateModified.month);
    return "$weekDayName, ${dateModified.day} $monthName ${dateModified.year}";
  }

  String getWeekDay(int weekDay) {
    if (weekDay == 1)
      return "Mon";
    else if (weekDay == 2)
      return "Tue";
    else if (weekDay == 3)
      return "Wed";
    else if (weekDay == 4)
      return "Thu";
    else if (weekDay == 5)
      return "Fri";
    else if (weekDay == 6)
      return "Sat";
    else
      return "Sun";
  }

  String getMonthName(int month) {
    if (month == 1)
      return "Jan";
    else if (month == 2)
      return "Feb";
    else if (month == 3)
      return "Mar";
    else if (month == 4)
      return "Apr";
    else if (month == 5)
      return "May";
    else if (month == 6)
      return "Jun";
    else if (month == 7)
      return "Jul";
    else if (month == 8)
      return "Aug";
    else if (month == 9)
      return "Sep";
    else if (month == 10)
      return "Oct";
    else if (month == 11)
      return "Nov";
    else
      return "Dec";
  }
}
