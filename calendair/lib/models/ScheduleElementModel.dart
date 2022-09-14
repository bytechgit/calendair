import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleElement {
  //String studentId;
  String docId;
  String type;
  String title;
  List<String> students;
  DateTime? date;
  DateTime dueDate;
  int time; //duration
  String note;
  bool checked;
  String? parentDocRef;
  int index;
  Random random = Random();
  final List _colors = [
    const Color.fromRGBO(217, 237, 249, 1),
    const Color.fromRGBO(247, 225, 237, 1),
    const Color.fromRGBO(248, 234, 213, 1),
    const Color.fromRGBO(218, 213, 249, 1),
    const Color.fromRGBO(226, 208, 198, 1)
  ];
  late Color color;
  late int colorIndex;

  //Map<String, dynamic> toMap() {
  // return {'id': docId, 'date': date, 'title': title, 'students': students};
  //}

  void setRandomColor(int? prevColorIndex) {
    if (prevColorIndex != null && colorIndex == prevColorIndex) {
      colorIndex = (colorIndex + 1) % 5;
      color = _colors[colorIndex];
    }
  }

  ScheduleElement.fromMap(Map<String, dynamic> map, this.docId, this.type)
      : date = map["date"] != null
            ? (map["date"] as Timestamp).toDate()
            : null, //((map["date"] ?? Timestamp(0, 0)) as Timestamp).toDate(),
        title = map["title"] ?? " ",
        index = map["index"] ?? -1,
        note = map["note"] ?? " ",
        time = map["time"] ?? 0,
        parentDocRef = map["parentDocRef"],
        checked = map["checked"] ?? false,
        dueDate = ((map["dueDate"] ?? Timestamp(0, 0)) as Timestamp).toDate(),
        students = ((map["students"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList() {
    colorIndex = random.nextInt(5);
    color = _colors[colorIndex];
  }
}
