import 'dart:developer';

import 'package:calendair/Classes/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/AssignmentModel.dart';
import '../models/ScheduleElementModel.dart';
import '../models/scheduleFindingResult.dart';

class ScheduleCintroller extends GetxController {
  final scheduleElements = Rx<List<List<ScheduleElement>>>(
      [[], [], [], [], [], [], [], [], [], [], [], [], [], []]);
  final totalTimes = Rx<List<int>>([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

  void listen(String uid) {
    scheduleElements.value = [
      [],
      [],
      [],
      [],
      [],
      [],
      [],
      [],
      [],
      [],
      [],
      [],
      [],
      []
    ];
    totalTimes.value = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    //!  TODO: treba da se pozove u login i mozda u register
    FirebaseFirestore.instance
        .collection('ScheduleReminders')
        .where("students", arrayContains: uid)
        .snapshots()
        .listen((e) {
      for (var doc in e.docChanges) {
        final ScheduleElement se = ScheduleElement.fromMap(
          doc.doc.data()!,
          doc.doc.id,
          "reminder",
        );
        if (doc.type == DocumentChangeType.modified) {
          var fse = findScheduleElement(se);
          if (fse != null) {
            if (fse.element.date!.isAtSameMomentAs(se.date!)) {
              fse.element.title = se.title;
            } else {
              removeFromScheduleElements(day: fse.dayId, index: fse.classId);
              //gc.scheduleElements.value[fse.dayId].removeAt(fse.classId);
              addInSchedule(se);
            }
            scheduleElements.refresh();
          } else {
            addInSchedule(se);
          }
        }
        if (doc.type == DocumentChangeType.added) {
          addInSchedule(se);
          // gc.scheduleElements.refresh();
        }
        if (doc.type == DocumentChangeType.removed) {
          var fse = findScheduleElement(se);
          if (fse != null) {
            removeFromScheduleElements(day: fse.dayId, index: fse.classId);
            // gc.scheduleElements.value[fse.dayId].removeAt(fse.classId);
            scheduleElements.refresh();
          }
        }
      }
    });

    FirebaseFirestore.instance
        .collection('Extracurriculars')
        .where("studentId", isEqualTo: uid)
        .snapshots()
        .listen((e) {
      for (var doc in e.docChanges) {
        final ScheduleElement se = ScheduleElement.fromMap(
            doc.doc.data()!, doc.doc.id, "extracurriculars");

        if (doc.type == DocumentChangeType.added) {
          addInSchedule(se);
        }
        if (doc.type == DocumentChangeType.modified) {
          var fse = findScheduleElement(se);
          if (fse != null) {
            if (fse.element.date!.isAtSameMomentAs(se.date!)) {
              fse.element.title = se.title;
              fse.element.time = se.time;
              print("UPDATEEEEE");
            } else {
              removeFromScheduleElements(day: fse.dayId, index: fse.classId);
              // gc.scheduleElements.value[fse.dayId].removeAt(fse.classId);
              addInSchedule(se);
              print("REMOVEEEEE");
            }
            scheduleElements.refresh();
          } else {
            addInSchedule(se);
          }
        }
        if (doc.type == DocumentChangeType.removed) {
          var fse = findScheduleElement(se);
          if (fse != null) {
            removeFromScheduleElements(day: fse.dayId, index: fse.classId);
            // gc.scheduleElements.value[fse.dayId].removeAt(fse.classId);
            scheduleElements.refresh();
          }
        }
      }
    });

    FirebaseFirestore.instance
        .collection('ScheduleAssignments')
        .where("studentId", isEqualTo: uid)
        .snapshots()
        .listen((e) async {
      for (var doc in e.docChanges) {
        inspect(doc.doc.data()!);
        ScheduleElement se =
            ScheduleElement.fromMap(doc.doc.data()!, doc.doc.id, "assignment");
        if (doc.type == DocumentChangeType.added) {
          addInSchedule(se);
        }
        if (doc.type == DocumentChangeType.modified) {
          var fse = findScheduleElement(se);
          if (fse != null) {
            if (fse.element.date!.isAtSameMomentAs(se.date!)) {
              fse.element.time = se.time;
              fse.element.note = se.note;
            } else {
              removeFromScheduleElements(day: fse.dayId, index: fse.classId);
              //gc.scheduleElements.value[fse.dayId].removeAt(fse.classId);
              addInSchedule(se);
            }
            scheduleElements.refresh();
          } else {
            addInSchedule(se);
          }
        }
      }
    });
  }

  int getDayIndex(DateTime dt) {
    DateTime dtn = DateTime.now();
    final nd = dtn.weekday;
    final startDate = dtn.subtract(Duration(days: nd - 1));
    final endDate = startDate.add(const Duration(days: 14));
    if (isInRange(startDate, dt, endDate)) {
      return dt.day - startDate.day;
    } else {
      return -1;
    }
  }

  bool isInRange(DateTime start, DateTime date, DateTime end) {
    start.subtract(Duration(
        minutes: start.minute,
        seconds: start.second,
        milliseconds: start.millisecond,
        microseconds: start.microsecond));
    end.subtract(Duration(
        minutes: end.minute,
        seconds: end.second,
        milliseconds: end.millisecond,
        microseconds: end.microsecond));
    return date.isAfter(start) && date.isBefore(end);
  }

  bool addInSchedule(ScheduleElement se) {
    if (se.type == "assignment" && se.date == null) {
      se.date = DateTime.now();
      updateScheduleElementDate(se);
    }
    int index = getDayIndex(se.date!);
    if (index != -1) {
      se.setRandomColor(scheduleElements.value[index].isNotEmpty
          ? scheduleElements.value[index].last.colorIndex
          : null);
      addInScheduleElements(newListIndex: index, se: se);
      //gc.scheduleElements.value[index].add(se);
      scheduleElements.refresh();
      return true;
    }
    return false;
  }

  FindingResult? findScheduleElement(ScheduleElement sc) {
    for (int i = 0; i < scheduleElements.value.length; i++) {
      var list = scheduleElements.value[i];
      for (int j = 0; j < list.length; j++) {
        if (list[j].docId == sc.docId) {
          return FindingResult(i, j, list[j]);
        }
      }
    }
    return null;
  }

  void updateScheduleElementDate(ScheduleElement se) {
    print(se.type);
    if (se.type == "assignment") {
      print("ASSSIGNMENT");

      FirebaseFirestore.instance
          .collection('ScheduleAssignments')
          .doc(se.docId)
          .update({
        "date": se.date,
        "index": se.index,
      });
    } else if (se.type == "extracurriculars") {
      FirebaseFirestore.instance
          .collection('Extracurriculars')
          .doc(se.docId)
          .update({
        "date": se.date,
        "index": se.index,
      });
    }
  }

  void addInScheduleElements({
    int? oldListIndex,
    required int newListIndex,
    required ScheduleElement se,
    int? index,
  }) {
    if (oldListIndex != null) {
      if (oldListIndex != newListIndex) {
        //!ako je promenjen dan
        final div = newListIndex - oldListIndex;
        se.date = se.date!.add(Duration(days: div));
        se.index = index ?? -1;
        updateScheduleElementDate(se);
      }
    }

    if (index != null) {
      scheduleElements.value[newListIndex].insert(index, se);
    } else {
      scheduleElements.value[newListIndex].add(se);
    }
    totalTimes.value[newListIndex] += se.time;
    totalTimes.refresh();
  }

  ScheduleElement removeFromScheduleElements(
      {required int day, required int index}) {
    print("remove");
    totalTimes.value[day] -= scheduleElements.value[day][index].time;
    totalTimes.refresh();
    return scheduleElements.value[day].removeAt(index);
  }
}
