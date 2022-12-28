import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  String docId;
  String courseId;
  Timestamp date;
  String title;
  List<DocumentReference> studentsCopy;
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'dueDate': date,
      'title': title,
      'studentsCopy': studentsCopy
    };
  }

  ReminderModel(
      {this.docId = "",
      required this.courseId,
      required this.date,
      required this.studentsCopy,
      required this.title});
  ReminderModel.fromMap(Map<String, dynamic> map, this.docId)
      : courseId = map["courseId"] ?? " ",
        date = map["dueDate"] ?? Timestamp(0, 0),
        title = map["title"] ?? " ",
        studentsCopy = ((map["studentsCopy"] ?? []) as List<dynamic>)
            .map((e) => e as DocumentReference)
            .toList();
}
