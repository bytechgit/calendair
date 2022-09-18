import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ScheduleElement {
  DateTime? date;
  String studentId;
  String docId;
  String type;
  String title;
  bool finished;
  int time = 0;
  int index;
  String get title_ {
    return title;
  }

  Map<String, dynamic> toMap() {
    return {};
  }

  void setRandomColor(int? prevColorIndex) {
    if (prevColorIndex != null && colorIndex == prevColorIndex) {
      colorIndex = (colorIndex + 1) % 5;
      color = _colors[colorIndex];
    }
  }

  Future<void> finish(bool finish) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: false);
    FirebaseFirestore.instance
        .collection("Schedule")
        .doc(docId)
        .update({"finished": finish});
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
      required this.index,
      this.finished = false,
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
  ScheduleElementReminder.fromMap(Map<String, dynamic> map, String docId)
      : super(
            date: map["date"] != null
                ? (map["date"] as Timestamp).toDate()
                : null,
            title: map["title"] ?? " ",
            studentId: map["studentId"] ?? " ",
            index: map["index"] ?? " ",
            docId: docId,
            type: map["type"] ?? "",
            finished: map["finished"] ?? false);
}

class ScheduleElementAssignment extends ScheduleElement {
  int timesec = 0;
  late DateTime dueDate;
  String pref = "";
  late String note;
  late String parentId;
  @override
  String get title_ {
    return "$pref $title";
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'title': title,
      'index': index,
      'studentId': studentId,
      'docId': docId,
      'type': type,
      'note': note,
      'parentId': parentId,
      'timesec': timesec,
      'pref': pref,
    };
  }

  ScheduleElementAssignment()
      : super(docId: "", studentId: "", title: "", type: "", index: 0) {
    dueDate = DateTime.now();
    note = "";
    parentId = "";
  }
  ScheduleElementAssignment.fromMap(Map<String, dynamic> map, String docId)
      : dueDate = ((map["dueDate"] ?? Timestamp(0, 0)) as Timestamp).toDate(),
        note = map["note"] ?? " ",
        parentId = map["parentId"] ?? " ",
        timesec = (map["time"] ?? 0) * 60,
        super(
            time: map["time"] ?? 0,
            date: map["date"] != null
                ? (map["date"] as Timestamp).toDate()
                : null,
            title: map["title"] ?? " ",
            index: map["index"] ?? " ",
            finished: map["finished"] ?? false,
            studentId: map["studentId"] ?? " ",
            docId: docId,
            type: map["type"] ?? "");
}

class ScheduleElementExtracurriculars extends ScheduleElement {
  String day;
  int dayIndex;
  ScheduleElementExtracurriculars.fromMap(
      Map<String, dynamic> map, String docId)
      : dayIndex = map["dayIndex"] ?? 0,
        day = map["day"] ?? " ",
        super(
          title: map["title"] ?? " ",
          studentId: map["studentId"] ?? " ",
          index: map["index"] ?? " ",
          docId: docId,
          finished: map["finished"] ?? false,
          type: map["type"] ?? "",
          time: map["time"] ?? 0,
        );
}
