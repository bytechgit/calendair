import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/iterables.dart';

class ExtracurricularsModel {
  String id;
  String studentId;
  String title;
  int time;
  int dayIndex;
  int index;

  // ExtracurricularsModel({required this.id,required this.studentId,required this.day});
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'title': title,
      'time': time,
      "dayIndex": dayIndex,
      "index": index
    };
  }

  ExtracurricularsModel.fromMap(Map<String, dynamic> map, String docId)
      : id = docId,
        studentId = map["studentId"] ?? " ",
        time = map["time"] ?? 0,
        dayIndex = map["dayIndex"] ?? 0,
        index = map["index"] ?? 1000,
        title = map["title"] ?? " ";
}
