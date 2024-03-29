import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/src/services/encrypter_class.dart';

class NoteModel {
  String? body;
  String? title;
  Timestamp dateCreated;
  bool isFavourite;
  String? noteId;
  String color;

  NoteModel(
      {required this.noteId,
      this.body,
      this.title,
      required this.dateCreated,
      required this.isFavourite,
      required this.color});

  NoteModel.fromDocSnapshotEncrypted(DocumentSnapshot documentSnapshot)
      : noteId = documentSnapshot.id,
        title = EncrypterClass.decryptText(string: documentSnapshot['title']),
        body = EncrypterClass.decryptText(string: documentSnapshot['body']),
        dateCreated = documentSnapshot['dateCreated'],
        isFavourite = documentSnapshot['isFavourite'],
        color = documentSnapshot['color'];

  NoteModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot)
      : noteId = documentSnapshot.id,
        title = documentSnapshot['title'],
        body = documentSnapshot['body'],
        dateCreated = documentSnapshot['dateCreated'],
        isFavourite = documentSnapshot['isFavourite'],
        color = documentSnapshot['color'];

  String get getDateCreated {
    var date = dateCreated.toDate();
    var monthName = getMonthName(date.month);
    if (date.difference(DateTime.now()) < Duration(days: 8)) {
      var weekDayName = getWeekDay(date.weekday);
      return "$weekDayName, ${date.day} $monthName ${date.year}";
    }
    return "${date.day} $monthName, ${date.year}";
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
