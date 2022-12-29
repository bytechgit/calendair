import 'package:calendair/schedule/schedule_element.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleElementExtracurricular extends ScheduleElement {
  int day;
  late List<int> finishedWeek;
  late Map<String, int> indexes;
  ScheduleElementExtracurricular(
      {required this.day,
      required int duration,
      String? docId,
      Map<String, int>? indexes,
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
    this.indexes = indexes ?? {};
    this.finishedWeek = finishedWeek ?? [];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'duration': duration,
      "finishedWeek": finishedWeek,
      "indexes": indexes,
      ...super.toMap()
    };
  }

  ScheduleElementExtracurricular.fromMap(
      {required Map<String, dynamic> map,
      required String docId,
      DocumentChangeType? changeType})
      : day = map["day"],
        indexes = Map.from(map["indexes"]),
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

  @override
  int getIndex({int? week}) {
    if (week == null) {
      return 0x7fffffff;
    }
    return indexes[week.toString()] ?? 0x7fffffff;
  }

  @override
  void setIndex({int? week, required int index}) {
    if (week != null) {
      indexes[week.toString()] = index;
    }
  }
}
