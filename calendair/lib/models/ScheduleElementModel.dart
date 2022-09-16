import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleElement {
  String studentId;
  String docId;
  String type;
  String title;
  bool checked = false;
  int time = 0;

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
    const Color.fromRGBO(226, 208, 198, 1)
  ];
  late Color color;
  late int colorIndex;
  ScheduleElement(
      {required this.studentId,
      required this.docId,
      required this.type,
      required this.title,
      this.time = 0,
      int? colorIndeks}) {
    if (colorIndeks != null) {
      colorIndex = colorIndeks;
    } else {
      colorIndex = Random().nextInt(5);
    }
    color = _colors[colorIndex];
  }
}

class ScheduleElementReminder extends ScheduleElement {
  DateTime? date;
  int index;
  ScheduleElementReminder.fromMap(Map<String, dynamic> map, String docId)
      : date = map["date"] != null ? (map["date"] as Timestamp).toDate() : null,
        index = map["index"] ?? -1,
        super(
            title: map["title"] ?? " ",
            studentId: map["studentId"] ?? " ",
            docId: docId,
            type: map["type"] ?? "");
}

class ScheduleElementAssignment extends ScheduleElement {
  List<DateTime> dates;
  DateTime dueDate;
  List<int> times = [];
  List<bool> finished = [];
  List<int> indexes = [];
  String note;
  ScheduleElementAssignment.fromMap(Map<String, dynamic> map, String docId)
      : dates = ((map["dates"] ?? []) as List<dynamic>)
            .map((e) => (e as Timestamp).toDate())
            .toList(),
        dueDate = ((map["dueDate"] ?? Timestamp(0, 0)) as Timestamp).toDate(),
        note = map["note"] ?? " ",
        times = ((map["times"] ?? []) as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        finished = ((map["finished"] ?? []) as List<dynamic>)
            .map((e) => e as bool)
            .toList(),
        indexes = ((map["indexes"] ?? []) as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        super(
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

class ScheduleElementAssignmentCopy extends ScheduleElement {
  int index;
  ScheduleElementAssignment assignemnt;
  late DateTime date;
  ScheduleElementAssignmentCopy({required this.index, required this.assignemnt})
      : super(
            docId: assignemnt.docId,
            studentId: assignemnt.studentId,
            title: index == 0
                ? "Start ${assignemnt.title}"
                : index == assignemnt.times.length - 1
                    ? "Finish ${assignemnt.title}"
                    : "Continue ${assignemnt.title}",
            type: assignemnt.type,
            time: assignemnt.times[index],
            colorIndeks: assignemnt.colorIndex) {
    date = assignemnt.dates[index];
  }
}
