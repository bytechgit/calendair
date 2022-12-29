import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleElement {
  int index;
  late String docId;
  DocumentChangeType changeType = DocumentChangeType.added;
  String title;
  String type;
  String studentId;
  int duration = 0;
  late Color color;
  int getIndex({int? week}) {
    return index;
  }

  void setIndex({int? week, required int index}) {
    this.index = index;
  }

  final List<Color> _colors = [
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
  ScheduleElement(
      {required this.index,
      String? docId,
      required this.title,
      required this.type,
      required this.studentId,
      this.duration = 0,
      Color? color,
      DocumentChangeType? changeType}) {
    this.docId = docId ?? "";
    this.changeType = changeType ?? DocumentChangeType.added;
    this.color = color ?? _colors[Random().nextInt(11)];
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'title': title,
      'studentId': studentId,
      'type': type,
      'color': color.value,
    };
  }

  ScheduleElement.fromMap(
      {required Map<String, dynamic> map,
      required this.docId,
      DocumentChangeType? changeType})
      : index = map["index"],
        // ignore: unnecessary_this
        this.changeType = changeType ?? DocumentChangeType.added,
        title = map["title"],
        duration = map["duration"] ?? 0,
        type = map["type"],
        studentId = map["studentId"] {
    color = map["color"] != null
        ? Color(map["color"])
        : _colors[Random().nextInt(11)];
  }

  bool isInRange(DateTime start, DateTime date, DateTime end) {
    if (start.compareTo(date) <= 0) {
      if (end.compareTo(date) >= 0) {
        return true;
      }
    }
    return false;
  }
}
