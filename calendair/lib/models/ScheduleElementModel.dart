import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleElement {
  DateTime? date;
  String studentId;
  String docId;
  String type;
  String title;
  bool checked = false;
  int time = 0;
  String get title_ {
    return title;
  }

  void setRandomColor(int? prevColorIndex) {
    if (prevColorIndex != null && colorIndex == prevColorIndex) {
      colorIndex = (colorIndex + 1) % 5;
      color = _colors[colorIndex];
    }
  }

  final List _colors = [
    const Color.fromRGBO(217, 237, 249, 1),
    const Color.fromRGBO(247, 225, 237, 1),
    const Color.fromRGBO(248, 234, 213, 1),
    const Color.fromRGBO(218, 213, 249, 1),
    const Color.fromRGBO(226, 208, 198, 1),
    const Color.fromRGBO(193, 246, 241, 1),
    const Color.fromRGBO(128, 154, 207, 1),
    const Color.fromRGBO(150, 184, 209, 1),
    const Color.fromRGBO(183, 224, 210, 1),
    const Color.fromRGBO(213, 233, 223, 1),
    const Color.fromRGBO(234, 196, 212, 1),
  ];
  late Color color;
  late int colorIndex;
  ScheduleElement(
      {required this.studentId,
      required this.docId,
      required this.type,
      required this.title,
      this.time = 0,
      int? colorIndeks,
      this.date}) {
    if (colorIndeks != null) {
      colorIndex = colorIndeks;
    } else {
      colorIndex = Random().nextInt(10);
    }
    color = _colors[colorIndex];
  }
}

class ScheduleElementReminder extends ScheduleElement {
  int index;
  ScheduleElementReminder.fromMap(Map<String, dynamic> map, String docId)
      : index = map["index"] ?? -1,
        super(
            date: map["date"] != null
                ? (map["date"] as Timestamp).toDate()
                : null,
            title: map["title"] ?? " ",
            studentId: map["studentId"] ?? " ",
            docId: docId,
            type: map["type"] ?? "");
}

class ScheduleElementAssignment extends ScheduleElement {
  DateTime dueDate;
  String pref = "";
  String note;
  String parentId;
  @override
  String get title_ {
    return "$pref $title";
  }

  ScheduleElementAssignment.fromMap(Map<String, dynamic> map, String docId)
      : dueDate = ((map["dueDate"] ?? Timestamp(0, 0)) as Timestamp).toDate(),
        note = map["note"] ?? " ",
        parentId = map["parentId"] ?? " ",
        super(
            time: map["time"] ?? 0,
            date: map["date"] != null
                ? (map["date"] as Timestamp).toDate()
                : null,
            title: map["title"] ?? " ",
            studentId: map["studentId"] ?? " ",
            docId: docId,
            type: map["type"] ?? "");
}

class ScheduleElementExtracurriculars extends ScheduleElement {
  String day;
  int dayIndex;
  int index;
  ScheduleElementExtracurriculars.fromMap(
      Map<String, dynamic> map, String docId)
      : index = map["index"] ?? -1,
        dayIndex = map["dayIndex"] ?? 0,
        day = map["day"] ?? " ",
        super(
          title: map["title"] ?? " ",
          studentId: map["studentId"] ?? " ",
          docId: docId,
          type: map["type"] ?? "",
          time: map["time"] ?? 0,
        );
}
