import 'dart:developer';

import 'package:calendair/models/schedule/scheduleElement.dart';
import 'package:calendair/models/schedule/scheduleElementAssignment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../classes/firestore.dart';

class ScheduleElementAssignmentMain extends ScheduleElement {
  List<DateTime> dates;
  DateTime dueDate;
  List<int> times;
  List<bool> finishedList;
  List<int> remainingTimes;
  List<String> materials;
  List<int> indexes;
  String note;

  Future<void> addDates() async {
    if (scheduleLists.timesList == null) {
      print("null");
    }
    scheduleLists.timesList ??= await Firestore().getTimes();

    int time = this.time;
    DateTime date = DateUtils.dateOnly(DateTime.now());
    DateTime minDate = DateUtils.dateOnly(DateTime.now());
    int minTime = 10000;
    int curTime = 0;
    while (time > 0) {
      int decrTime = time > 45 ? 30 : time;
      times.add(decrTime);
      remainingTimes.add(decrTime);
      time -= decrTime;
      minTime = 10000;
      minDate = DateUtils.dateOnly(DateTime.now());
      date = DateUtils.dateOnly(DateTime.now());
      finishedList.add(false);
      indexes.add(1000);
      //inicijalno na 1000 jer se stavlj na kraj dana
      while (date.compareTo(dueDate) <= 0) {
        if (date.weekday - 1 != Firestore().firebaseUser!.breakday) {
          curTime =
              scheduleLists.timesList?[DateUtils.dateOnly(date).toString()] ??
                  0;
          if (curTime < minTime) {
            minTime = curTime;
            minDate = date;
          }
        }
        date = date.add(const Duration(days: 1));
      }
      dates.add(minDate);
      scheduleLists.timesList?[DateUtils.dateOnly(minDate).toString()] =
          (scheduleLists.timesList?[DateUtils.dateOnly(minDate).toString()] ??
                  0) +
              decrTime;
    }
    FirebaseFirestore.instance.collection("Schedule").doc(docId).update({
      "dates": dates,
      "indexes": indexes,
      "finishedList": finishedList,
      "times": times,
      "remainingTimes": remainingTimes
    });
    await Firestore().setTimes(scheduleLists.timesList!);
  }

  ScheduleElementAssignmentMain(
      String title, String type, String docId, int index, String studentId,
      {required this.dates,
      required this.dueDate,
      required this.finishedList,
      required this.indexes,
      required this.note,
      required this.times,
      required this.remainingTimes,
      required this.materials})
      : super(
            title: title,
            docId: docId,
            index: index,
            type: type,
            studentId: studentId);
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
      'finishedList': finishedList,
      'indexes': indexes,
      'dates': dates.map((e) => Timestamp.fromDate(e)).toList(),
      'times': times,
    };
  }

  @override
  Future<void> addInSchedule({int? listIndex, int? index}) async {
    if (dates.isEmpty) {
      await addDates();
    }
    ScheduleElementAssignment? s;
    for (int i = 0; i < dates.length; i++) {
      s = ScheduleElementAssignment.fromMain(this, i);
      s.addInSchedule();
    }
    if (s != null) {
      scheduleLists.addPrefix(s);
    }
    super.addInSchedule();
  }

  @override
  void modifieSchdeuleElement() {
    //!kasnije
  }

  ScheduleElementAssignmentMain.fromMap(Map<String, dynamic> map, String docId)
      : dates = ((map["dates"] ?? []) as List<dynamic>)
            .map((e) => (e as Timestamp).toDate())
            .toList(),
        dueDate = ((map["dueDate"] ?? Timestamp(0, 0)) as Timestamp).toDate(),
        note = map["note"] ?? " ",
        times = ((map["times"] ?? []) as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        finishedList = ((map["finishedList"] ?? []) as List<dynamic>)
            .map((e) => e as bool)
            .toList(),
        remainingTimes = ((map["remainingTimes"] ?? []) as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        indexes = ((map["indexes"] ?? []) as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        materials = ((map["materials"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        super(
            time: map["time"] ?? 0,
            date: map["date"] != null
                ? (map["date"] as Timestamp).toDate()
                : null,
            title: map["title"] ?? " ",
            index: map["index"] ?? 0,
            finished: map["finished"] ?? false,
            studentId: map["studentId"] ?? " ",
            docId: docId,
            type: map["type"] ?? "");
}
