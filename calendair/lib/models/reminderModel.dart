import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  String classId;
  Timestamp date;
  String title;
  Map<String, dynamic> toMap() {
    return {
      'id': classId,
      'date': date,
      'title': title,
    };
  }

  ReminderModel.fromMap(Map<String, dynamic> map)
      : classId = map["id"] ?? "fgfd ",
        date = map["date"] ?? Timestamp(0, 0),
        title = map["title"] ?? " fgd";
}
