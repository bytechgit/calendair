import 'package:calendair/schedule/schedule_element.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleElementReminder extends ScheduleElement {
  DateTime date;
  ScheduleElementReminder(
      {required this.date,
      String? docId,
      DocumentChangeType? changeType,
      required int index,
      required String title,
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
            changeType: changeType);

  @override
  Map<String, dynamic> toMap() {
    return {'dueDate': date, ...super.toMap()};
  }

  ScheduleElementReminder.fromMap(
      {required Map<String, dynamic> map,
      required String docId,
      DocumentChangeType? changeType})
      : date = (map["dueDate"] as Timestamp).toDate(),
        super.fromMap(map: map, docId: docId, changeType: changeType);

  int get dayIndex {
    DateTime dtn = DateTime.now();
    final nd = dtn.weekday;
    final startDate = DateUtils.dateOnly(dtn.subtract(Duration(days: nd - 1)));
    final endDate = DateUtils.dateOnly(startDate.add(const Duration(days: 13)));
    if (isInRange(startDate, DateUtils.dateOnly(date), endDate)) {
      return date.difference(startDate).inDays;
    } else {
      return -1;
    }
  }
}
