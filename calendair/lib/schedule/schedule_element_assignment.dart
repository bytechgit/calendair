import 'package:calendair/schedule/assignment_element.dart';
import 'package:calendair/schedule/schedule_element.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleElementAssignment extends ScheduleElement {
  int positionIndex;
  String prefix = "";
  String get prefixtitle {
    return "$prefix $title";
  }

  AssignmentElement assignmentRef;
  ScheduleElementAssignment(
      {required this.positionIndex, required this.assignmentRef})
      : super(
            index: assignmentRef.getIndex(),
            title: assignmentRef.title,
            studentId: assignmentRef.studentId,
            type: assignmentRef.type,
            docId: assignmentRef.docId,
            color: assignmentRef.color,
            changeType: assignmentRef.changeType);

  int get dayIndex {
    DateTime dtn = DateTime.now();
    final nd = dtn.weekday;
    final startDate = DateUtils.dateOnly(dtn.subtract(Duration(days: nd - 1)));
    final endDate = DateUtils.dateOnly(startDate.add(const Duration(days: 13)));
    if (isInRange(startDate,
        DateUtils.dateOnly(assignmentRef.dates[positionIndex]), endDate)) {
      return assignmentRef.dates[positionIndex].difference(startDate).inDays;
    } else {
      return -1;
    }
  }

  @override
  int get index {
    return assignmentRef.indexes[positionIndex];
  }

  @override
  set index(int index) {
    assignmentRef.indexes[positionIndex] = index;
  }

  bool get finished {
    return assignmentRef.remainingTimes[positionIndex] == 0;
  }

  set finished(bool finished) {
    assignmentRef.remainingTimes[positionIndex] =
        finished == true ? 0 : assignmentRef.times[positionIndex] * 60;
  }

  DateTime get date {
    return assignmentRef.dates[positionIndex];
  }

  set date(DateTime date) {
    assignmentRef.dates[positionIndex] = date;
  }

  @override
  int get duration {
    return assignmentRef.times[positionIndex];
  }

  set remainingTime(int time) {
    assignmentRef.remainingTimes[positionIndex] = time;
  }

  int get remainingTime {
    return assignmentRef.remainingTimes[positionIndex];
  }

  void finish(bool finished) {
    this.finished = finished;
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"remainingTimes": assignmentRef.remainingTimes});
  }

  void updateRemainingTime(int time) {
    remainingTime = time;
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"remainingTimes": assignmentRef.remainingTimes});
  }
}
