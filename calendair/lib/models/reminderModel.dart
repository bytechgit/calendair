import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  String id;
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

  ReminderModel.fromMap(Map<String, dynamic> map, String docId)
      : id = docId,
        classId = map["id"] ?? " ",
        date = map["date"] ?? Timestamp(0, 0),
        title = map["title"] ?? " ";
}
