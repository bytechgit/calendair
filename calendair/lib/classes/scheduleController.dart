import 'package:calendair/Classes/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/ScheduleElementModel.dart';
import '../models/scheduleFindingResult.dart';
import 'ExtButton.dart';

class ScheduleCintroller extends GetxController {
  final scheduleElements = Rx<List<List<ScheduleElement>>>(
      [[], [], [], [], [], [], [], [], [], [], [], [], [], []]);
  final totalTimes = Rx<List<int>>([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
  final breakday = Get.find<ExtButton>();
  Map<String, dynamic>? times;

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
    FirebaseFirestore.instance
        .collection('Schedule')
        .where("studentId", isEqualTo: uid)
        .orderBy("date")
        .orderBy("index")
        .snapshots()
        .listen((e) {
      ScheduleElement? se;
      for (var doc in e.docChanges) {
        print((doc.doc.data()!)["type"]);
        switch ((doc.doc.data()!)["type"] as String) {
          case "reminder":
            se = ScheduleElementReminder.fromMap(doc.doc.data()!, doc.doc.id);
            break;
          case "assignment":
            se = ScheduleElementAssignmentMain.fromMap(
                doc.doc.data()!, doc.doc.id);
            break;
          case "extracurricular":
            se = ScheduleElementExtracurriculars.fromMap(
                doc.doc.data()!, doc.doc.id);
            break;
          default:
        }
        if (se != null) {
          if (doc.type == DocumentChangeType.added) {
            addInSchedule(se);
          } else if (doc.type == DocumentChangeType.modified) {
            modifieSchdeuleElement(se);
          } else if (doc.type == DocumentChangeType.removed) {
            removeFromScheduleElements(se1: se);
          }
        }
      }
    });
  }

  int getDayIndex(DateTime dt) {
    DateTime dtn = DateTime.now();
    final nd = dtn.weekday;
    final startDate = DateUtils.dateOnly(dtn.subtract(Duration(days: nd - 1)));
    final endDate = DateUtils.dateOnly(startDate.add(const Duration(days: 13)));
    if (isInRange(startDate, DateUtils.dateOnly(dt), endDate)) {
      return dt.day - startDate.day;
    } else {
      return -1;
    }
  }

  bool isInRange(DateTime start, DateTime date, DateTime end) {
    if (start.compareTo(date) <= 0) {
      if (end.compareTo(date) >= 0) {
        return true;
      }
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

  // void updateScheduleElementDate(
  //     ScheduleElement se, int oldIndex, int newIndex) {
  //   final doc = FirebaseFirestore.instance.collection('Schedule').doc(se.docId);
  //   if (se is ScheduleElementAssignment) {
  //     final ind = newIndex - oldIndex;
  //     se.date = se.date!.add(Duration(days: ind));
  //     doc.update({
  //       "date": se.date,
  //       //"index": se.index,
  //     });
  //   } else if (se is ScheduleElementExtracurriculars) {
  //     se.dayIndex = newIndex % 7;
  //     doc.update({
  //       "dayIndex": se.dayIndex,
  //       //"index": se.index,
  //     });
  //   } else if (se is ScheduleElementReminder) {
  //     final ind = newIndex - oldIndex;
  //     se.date = se.date!.add(Duration(days: ind));
  //     //se.index = index ?? -1;
  //     doc.update({
  //       "date": se.date,
  //     });
  //   }
  // }

  void addInScheduleElements({
    required int oldListIndex,
    required int newListIndex,
    required ScheduleElement se,
    required int index,
  }) {
    if (oldListIndex != newListIndex) {
      se.updateDate(newListIndex: newListIndex, oldListIndex: oldListIndex);
    }

    if (se is ScheduleElementExtracurriculars) {
      if (index >= scheduleElements.value[newListIndex].length) {
        scheduleElements.value[newListIndex].add(se);
      } else {
        scheduleElements.value[newListIndex].insert(index, se);
      }
      totalTimes.value[se.dayIndex] += se.time;
      totalTimes.value[se.dayIndex + 7] += se.time;

      if (index >= scheduleElements.value[(newListIndex + 7) % 14].length) {
        scheduleElements.value[(newListIndex + 7) % 14].add(se);
      } else {
        scheduleElements.value[(newListIndex + 7) % 14].insert(index, se);
      }
    } else {
      scheduleElements.value[newListIndex].insert(index, se);
      totalTimes.value[newListIndex] += se.time;
    }
    if (se is ScheduleElementAssignment) {
      addPrefix(se);
    }
    updateIndexes(newListIndex, index);

    totalTimes.refresh();
  }

  ScheduleElement removeFromScheduleElements(
      {ScheduleElement? se1, int? listIndex, int? index}) {
    FindingResult? fe;
    if (se1 != null) {
      fe = findScheduleElement(se1);
    } else {
      fe = FindingResult(
          listIndex!, index!, scheduleElements.value[listIndex][index]);
      se1 = scheduleElements.value[listIndex][index];
    }

    if (fe != null) {
      if (se1 is ScheduleElementReminder) {
        scheduleElements.value[fe.dayId].removeAt(fe.classId);
        scheduleElements.refresh();
        return se1;
      } else if (se1 is ScheduleElementExtracurriculars) {
        scheduleElements.value[fe.dayId].removeAt(fe.classId);
        int index2 = (fe.dayId + 7) % 14;
        scheduleElements.value[index2]
            .removeWhere((element) => element.docId == se1!.docId);
        totalTimes.value[fe.dayId] -= se1.time;
        totalTimes.value[index2] -= se1.time;
        totalTimes.refresh();
        scheduleElements.refresh();
        return se1;
      } else if (se1 is ScheduleElementAssignment) {
        scheduleElements.value[fe.dayId].removeAt(fe.classId);
        totalTimes.value[fe.dayId] -= se1.time;
        totalTimes.refresh();
        scheduleElements.refresh();
        return se1;
      } else {
        return se1;
      }
    } else {
      return se1;
    }
  }

  Future<bool> addInSchedule(ScheduleElement se) async {
    if (se is ScheduleElementReminder) {
      int index = getDayIndex(se.date!);
      if (index != -1) {
        if (breakday.breakdayIndex.value == index) {
          index += 1;
        }
        scheduleElements.value[index].insert(0, se);
        scheduleElements.value[index]
            .sort(((a, b) => a.index.compareTo(b.index)));
        return true;
      } else {
        return false;
      }
    } else if (se is ScheduleElementExtracurriculars) {
      scheduleElements.value[se.dayIndex].add(se);
      scheduleElements.value[se.dayIndex + 7].add(se);
      scheduleElements.value[se.dayIndex]
          .sort(((a, b) => a.index.compareTo(b.index)));
      scheduleElements.value[se.dayIndex + 7]
          .sort(((a, b) => a.index.compareTo(b.index)));
      totalTimes.value[se.dayIndex] += se.time;
      totalTimes.value[se.dayIndex + 7] += se.time;
      totalTimes.refresh();
      scheduleElements.refresh();
    } else if (se is ScheduleElementAssignmentMain) {
      if (se.dates.isEmpty) {
        await addDates(se);
      }
      int i = 0;
      ScheduleElementAssignment? s;
      for (var date in se.dates) {
        s = ScheduleElementAssignment.fromMain(se, i);
        i++;
        int index = getDayIndex(date);
        if (index != -1) {
          scheduleElements.value[index].add(s);
          totalTimes.value[index] += s.time;
          totalTimes.refresh();
        }
        scheduleElements.value[index]
            .sort(((a, b) => a.index.compareTo(b.index)));
      }
      if (s != null) {
        addPrefix(s);
      }
    }
    return false;
  }

  void modifieSchdeuleElement(ScheduleElement se) {
    final fse = findScheduleElement(se);
    if (fse != null) {
      if (se is ScheduleElementReminder) {
        if ((fse.element as ScheduleElementReminder)
            .date!
            .isAtSameMomentAs(se.date!)) {
          (fse.element as ScheduleElementReminder).index = se.index;
          fse.element.title = se.title;
        } else {
          removeFromScheduleElements(se1: se);
          addInSchedule(se);
        }
      }
      if (se is ScheduleElementExtracurriculars) {
        if (se.dayIndex ==
            (fse.element as ScheduleElementExtracurriculars).dayIndex) {
          (fse.element as ScheduleElementExtracurriculars).time = se.time;
          fse.element.title = se.title;
        } else {
          removeFromScheduleElements(se1: se);
          addInSchedule(se);
        }
      }
      if (se is ScheduleElementAssignmentMain) {
        //!kasnije treba da se izmeni
        // removeFromScheduleElements(se1: se);
        //addInSchedule(se);
      }
    } else {
      addInSchedule(se);
    }
    scheduleElements.refresh();
  }

  // DateTime getDate(ScheduleElementAssignment sea) {
  //   final days = daysBetween(DateTime.now(),
  //       /*sea.dueDate*/ DateTime.now().add(const Duration(days: 7)));
  //   List<int> times = [];
  //   final weekday = DateTime.now().weekday - 1;
  //   for (int i = weekday; i < days + weekday; i++) {
  //     if (i < 14) {
  //       if (breakday.breakdayIndex.value != -1 &&
  //           (i == breakday.breakdayIndex.value + 1 ||
  //               i == breakday.breakdayIndex.value + 1 + 7)) {
  //         times.add(100000);
  //       } else {
  //         times.add(totalTimes.value[i]);
  //       }
  //     } else {
  //       times.add(0);
  //     }
  //   }
  //   int index = minIndex(times);
  //   return DateUtils.dateOnly(DateTime.now().add(Duration(days: index)));
  // }

  // int minIndex(List<int> l) {
  //   int minel = 10000;
  //   int mini = 0;
  //   for (int i = 0; i < l.length; i++) {
  //     if (l[i] < minel) {
  //       minel = l[i];
  //       mini = i;
  //     }
  //   }
  //   return mini;
  // }

  // int daysBetween(DateTime from, DateTime to) {
  //   from = DateTime(from.year, from.month, from.day);
  //   to = DateTime(to.year, to.month, to.day);
  //   return (to.difference(from).inHours / 24).round();
  // }

  // void updateIndex(ScheduleElement se, index) {
  //   if (se is ScheduleElementExtracurriculars) {}
  // }

  void addPrefix(ScheduleElementAssignment se) {
    final f = scheduleElements.value
        .expand((element) => element)
        .whereType<ScheduleElementAssignment>()
        .toList();
    final list = f.where((element) => (element).docId == se.docId);
    for (var element in list) {
      element.pref = "Continue";
      element.color = list.first.color;
    }
    final first = f.firstWhereOrNull((element) => (element).docId == se.docId);
    first?.pref = "Start";

    final last = f.lastWhere(
      (element) => (element).docId == se.docId,
      orElse: () {
        return ScheduleElementAssignment();
      },
    );
    last.pref = "Finish";
    scheduleElements.refresh();
  }

  Future<void> updateIndexes(int listIndex, int itemIndex) async {
    // for (int i = itemIndex; i < scheduleElements.value[listIndex].length; i++) {
    //   await FirebaseFirestore.instance
    //       .collection('Schedule')
    //       .doc(scheduleElements.value[listIndex][i].docId)
    //       .update({"index": i});
    // }
    for (int i = 0; i < scheduleElements.value[listIndex].length; i++) {
      if (scheduleElements.value[listIndex][i] is! ScheduleElementReminder) {
        scheduleElements.value[listIndex][i].updateIndex(i);
      }
    }
  }

  Future<void> addDates(ScheduleElementAssignmentMain sm) async {
    times ??= await Firestore().getTimes();
    int time = sm.time;
    DateTime date = DateUtils.dateOnly(DateTime.now());
    DateTime minDate = DateUtils.dateOnly(DateTime.now());
    int minTime = 10000;
    int curTime = 0;
    while (time > 0) {
      int decrTime = time > 45 ? 30 : time;
      sm.times.add(decrTime);
      time -= decrTime;
      minTime = 10000;
      minDate = DateUtils.dateOnly(DateTime.now());
      date = DateUtils.dateOnly(DateTime.now());
      sm.finishedList.add(false);
      sm.indexes.add(1000);
      //inicijalno na 1000 jer se stavlj na kraj dana
      while (date.compareTo(sm.dueDate) <= 0) {
        if (date.weekday - 1 != breakday.breakdayIndex.value) {
          curTime = times?[DateUtils.dateOnly(date).toString()] ?? 0;
          if (curTime < minTime) {
            minTime = curTime;
            minDate = date;
          }
        }
        date = date.add(const Duration(days: 1));
      }
      sm.dates.add(minDate);
      times?[DateUtils.dateOnly(minDate).toString()] =
          (times?[DateUtils.dateOnly(minDate).toString()] ?? 0) + decrTime;
    }
    FirebaseFirestore.instance.collection("Schedule").doc(sm.docId).update({
      "dates": sm.dates,
      "indexes": sm.indexes,
      "finishedList": sm.finishedList,
      "times": sm.times
    });
    Firestore().setTimes(times!);
  }
}
