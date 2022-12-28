import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModel {
  String? note;
  String courseId;
  String docId;
  String assignmentId;
  int duration;
  DateTime dueDate;
  String title;
  List<DocumentReference<Map<String, dynamic>>> studentsCopy = [];
  List<String> materials;
  AssignmentModel(
      {this.note,
      required this.assignmentId,
      required this.docId,
      required this.courseId,
      required this.title,
      required this.duration,
      required this.materials,
      required this.dueDate});
  Map<String, dynamic> toMap() {
    return {
      'note': note,
      'courseId': courseId,
      'duration': duration,
      'dueDate': dueDate,
      'title': title,
      "assignmentId": assignmentId,
      "studentsCopy": studentsCopy,
      "materials": materials,
    };
  }

  AssignmentModel.fromMap(Map<String, dynamic> map, this.docId)
      : note = map["note"],
        courseId = map["courseId"],
        assignmentId = map["assignmentId"],
        title = map["title"] ?? "no title",
        duration = map["duration"] ?? 0,
        dueDate = ((map["dueDate"] ?? Timestamp(0, 0)) as Timestamp).toDate(),
        studentsCopy = ((map["studentsCopy"] ?? []) as List<dynamic>)
            .map((e) => e as DocumentReference<Map<String, dynamic>>)
            .toList(),
        materials = (map["materials"] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
}
