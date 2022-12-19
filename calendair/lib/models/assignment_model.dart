import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/classroom/v1.dart';

class AssignmentModel {
  String? note;
  String courseId;
  String docId;
  String assignmentId;
  int duration;
  DateTime? dueDate;
  String title;
  List<DocumentReference<Map<String, dynamic>>> studentsCopy = [];
  List<Material>? materials;
  AssignmentModel(
      {this.note,
      required this.assignmentId,
      required this.docId,
      required this.courseId,
      required this.title,
      required this.duration,
      this.materials});
  Map<String, dynamic> toMap() {
    return {
      'note': note,
      'courseId': courseId,
      'duration': duration,
      'dueDate': dueDate ?? DateTime.now().add(const Duration(days: 7)),
      'title': title,
      "assignmentId": assignmentId,
      "studentsCopy": studentsCopy
    };
  }

  AssignmentModel.fromMap(Map<String, dynamic> map, this.docId)
      : note = map["note"],
        courseId = map["courseId"],
        assignmentId = map["assignmentId"],
        title = map["title"] ?? "no title",
        duration = map["duration"] ?? 0,
        dueDate = ((map["dueDate"] ?? Timestamp(0, 0)) as Timestamp).toDate() {}
}
