import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/iterables.dart';

class ExtracurricularsModel {
  String id;
  String studentId;
  String day;
  String title;
  int time;
  DateTime date;

  // ExtracurricularsModel({required this.id,required this.studentId,required this.day});
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'day': day,
      'title': title,
      'time': time,
      "date": date
    };
  }

  ExtracurricularsModel.fromMap(Map<String, dynamic> map, String docId)
      : id = docId,
        studentId = map["studentId"] ?? " ",
        time = map["time"] ?? 0,
        day = map["day"] ?? " ",
        date = ((map["date"] ?? Timestamp(0, 0)) as Timestamp).toDate(),
        title = map["title"] ?? " ";
}
