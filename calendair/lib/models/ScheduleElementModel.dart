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

  void updateIndex(int index) {
    this.index = index;
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"index": index});
  }

  void updateDate({required int newListIndex, required int oldListIndex}) {
    final ind = newListIndex - oldListIndex;
    date = date?.add(Duration(days: ind));
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"date": date});
  }

  void finish(bool f) {
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"finished": f});
  }

  // void setRandomColor(int? prevColorIndex) {
  //   if (prevColorIndex != null && colorIndex == prevColorIndex) {
  //     colorIndex = (colorIndex + 1) % 5;
  //     color = _colors[colorIndex];
  //   }
  // }

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

class ScheduleElementAssignment extends ScheduleElementAssignmentMain {
  int timesec = 0;
  int i = 0;
  String pref = "";
  @override
  String get title_ {
    return "$pref $title";
  }

  ScheduleElementAssignment.fromMain(ScheduleElementAssignmentMain m, this.i)
      : super(m.title, m.type, m.docId, m.index, m.studentId,
            dates: m.dates,
            dueDate: m.dueDate,
            times: m.times,
            finishedList: m.finishedList,
            note: m.note,
            indexes: m.indexes) {
    index = m.indexes[i];
    finished = m.finishedList[i];
    date = m.dates[i];
    time = m.times[i];
    timesec = time * 60;
    dates = m.dates;
  }

  @override
  void updateIndex(int index) {
    indexes[i] = index;
    this.index = index;
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"indexes": indexes});
  }

  @override
  void updateDate({required int newListIndex, required int oldListIndex}) {
    final ind = newListIndex - oldListIndex;
    date = dates[i].add(Duration(days: ind));
    dates[i] = dates[i].add(Duration(days: ind));
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"dates": dates});
  }

  @override
  void finish(bool f) {
    finished = f;
    finishedList[i] = f;
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"finishedList": finishedList});
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
      'timesec': timesec,
      'pref': pref,
      'finishedList': finishedList,
      'indexes': indexes,
      'dates': dates,
      'times': times,
    };
  }

  Future<void> finishFromBackend(bool finish) async {
    finishedList[i] = finish;
    finished = finish;
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: false);
    FirebaseFirestore.instance
        .collection("Schedule")
        .doc(docId)
        .update({"finishedList": finishedList});
  }

  ScheduleElementAssignment() : super.fromMap({}, "");
  ScheduleElementAssignment.fromMap(Map<String, dynamic> map, String docId)
      : super.fromMap(map, docId);
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
  @override
  void updateDate({required int newListIndex, required int oldListIndex}) {
    dayIndex = newListIndex % 7;
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"dayIndex": dayIndex});
  }
}

class ScheduleElementAssignmentMain extends ScheduleElement {
  List<DateTime> dates;
  DateTime dueDate;
  List<int> times;
  List<bool> finishedList;
  List<int> indexes;
  String note;

  ScheduleElementAssignmentMain(
      String title, String type, String docId, int index, String studentId,
      {required this.dates,
      required this.dueDate,
      required this.finishedList,
      required this.indexes,
      required this.note,
      required this.times})
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
        indexes = ((map["indexes"] ?? []) as List<dynamic>)
            .map((e) => e as int)
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
