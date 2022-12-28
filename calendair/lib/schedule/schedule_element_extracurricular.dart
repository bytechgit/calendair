import 'package:calendair/schedule/schedule_element.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleElementExtracurricular extends ScheduleElement {
  int day;
  late List<int> finishedWeek;
  ScheduleElementExtracurricular(
      {required this.day,
      required int duration,
      String? docId,
      DocumentChangeType? changeType,
      required int index,
      required String title,
      List<int>? finishedWeek,
      required String type,
      required String studentId,
      Color? color})
      : super(
            index: index,
            title: title,
            studentId: studentId,
            type: type,
            docId: docId,
            color: color,
            duration: duration,
            changeType: changeType) {
    this.finishedWeek = finishedWeek ?? [];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'duration': duration,
      "finishedWeek": finishedWeek,
      ...super.toMap()
    };
  }

  ScheduleElementExtracurricular.fromMap(
      {required Map<String, dynamic> map,
      required String docId,
      DocumentChangeType? changeType})
      : day = map["day"],
        finishedWeek = (map["finishedWeek"] as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        super.fromMap(map: map, docId: docId, changeType: changeType);

  bool finished(int week) {
    return (finishedWeek.contains(week));
  }

  void finish({required int week, required bool finish}) {
    if (finish) {
      finishedWeek.add(week);
    } else {
      finishedWeek.remove(week);
    }
    FirebaseFirestore.instance
        .collection('Extracurriculars')
        .doc(docId)
        .update({"finishedWeek": finishedWeek});
  }
}
