import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  String id;
  String classId;
  Timestamp date;
  String title;
  List<String> students;
  Map<String, dynamic> toMap() {
    return {'id': classId, 'date': date, 'title': title, 'students': students};
  }

  ReminderModel.fromMap(Map<String, dynamic> map, String docId)
      : id = docId,
        classId = map["id"] ?? " ",
        date = map["date"] ?? Timestamp(0, 0),
        title = map["title"] ?? " ",
        students = ((map["students"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
}
