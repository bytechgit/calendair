import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/classroom/v1.dart';

class MyAssignment {
  late String? note;
  late int duration;
  late DateTime dueDate;
  late String title;
  late CourseWork? coursework;
  MyAssignment(this.note, this.duration, this.coursework);

  MyAssignment.fromMap(Map<String, dynamic> map, CourseWork? cw)
      : coursework = cw,
        note = map["note"],
        title = map["title"] ?? "no title",
        duration = map["duration"] ?? 0,
        dueDate = ((map["dueDate"] ?? Timestamp(0, 0)) as Timestamp).toDate() {}
}
