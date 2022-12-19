import 'dart:math';
import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/controllers/schedule_lists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleElement {
  DateTime? date;
  String studentId;
  String docId;
  String type;
  String title;
  bool finished;
  int time = 0;
  int index;
  final scheduleLists = Get.find<ScheduleLists>();
  late Color color;
  late int colorIndex;
  String get title_ {
    return title;
  }

  Map<String, dynamic> toMap() {
    return {};
  }

  void updateIndex(int index) {
    this.index = index;
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"index": index});
  }

  bool isInRange(DateTime start, DateTime date, DateTime end) {
    if (start.compareTo(date) <= 0) {
      if (end.compareTo(date) >= 0) {
        return true;
      }
    }
    return false;
  }

  void addInSchedule({int? listIndex, int? index, FirebaseController? ua}) {}
  void removeFromSchedule({int? listIndex, int? index}) {}
  void modifieSchdeuleElement() {}

  int getDayIndex() {
    if (date == null) {
      return -1;
    }
    DateTime dtn = DateTime.now();
    final nd = dtn.weekday;
    final startDate = DateUtils.dateOnly(dtn.subtract(Duration(days: nd - 1)));
    final endDate = DateUtils.dateOnly(startDate.add(const Duration(days: 13)));
    if (isInRange(startDate, DateUtils.dateOnly(date!), endDate)) {
      return date!.difference(startDate).inDays;
    } else {
      return -1;
    }
  }

  void updateDate({required int newListIndex, required int oldListIndex}) {
    final ind = newListIndex - oldListIndex;
    date = date?.add(Duration(days: ind));
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"date": date});
  }

  void finish(bool f, {int? time}) {
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"finished": f});
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
