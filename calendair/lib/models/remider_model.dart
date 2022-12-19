import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  String docId;
  String classId;
  Timestamp date;
  String title;
  List<DocumentReference> studentsCopy;
  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'date': date,
      'title': title,
      'studentsCopy': studentsCopy
    };
  }

  ReminderModel(
      {required this.classId,
      required this.date,
      required this.docId,
      required this.studentsCopy,
      required this.title});
  ReminderModel.fromMap(Map<String, dynamic> map, this.docId)
      : classId = map["classId"] ?? " ",
        date = map["date"] ?? Timestamp(0, 0),
        title = map["title"] ?? " ",
        studentsCopy = ((map["studentsCopy"] ?? []) as List<dynamic>)
            .map((e) => e as DocumentReference)
            .toList();
}
