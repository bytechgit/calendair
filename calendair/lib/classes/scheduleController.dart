import 'dart:developer';
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
            se = ScheduleElementAssignment.fromMap(doc.doc.data()!, doc.doc.id);
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

  void updateScheduleElementDate(
      ScheduleElement se, int oldIndex, int newIndex) {
    final doc = FirebaseFirestore.instance.collection('Schedule').doc(se.docId);
    if (se is ScheduleElementAssignment) {
      final ind = newIndex - oldIndex;
      se.date = se.date!.add(Duration(days: ind));
      doc.update({
        "date": se.date,
        //"index": se.index,
      });
    } else if (se is ScheduleElementExtracurriculars) {
      se.dayIndex = newIndex % 7;
      doc.update({
        "dayIndex": se.dayIndex,
        //"index": se.index,
      });
    } else if (se is ScheduleElementReminder) {
      final ind = newIndex - oldIndex;
      se.date = se.date!.add(Duration(days: ind));
      //se.index = index ?? -1;
      doc.update({
        "date": se.date,
      });
    }
  }

  void addInScheduleElements({
    required int oldListIndex,
    required int newListIndex,
    required ScheduleElement se,
    required int index,
  }) {
    if (oldListIndex != newListIndex) {
      //!index je mozda pomenren
      updateScheduleElementDate(se, oldListIndex, newListIndex);
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
      updateIndexes(newListIndex, index);
    }

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

  bool addInSchedule(ScheduleElement se) {
    //! treba da se azuriraju indeksi
    if (se is ScheduleElementReminder) {
      inspect(se);
      int index = getDayIndex(se.date!);
      if (index != -1) {
        scheduleElements.value[index].insert(0, se);
        return true;
      } else {
        return false;
      }
    } else if (se is ScheduleElementExtracurriculars) {
      scheduleElements.value[se.dayIndex].add(se);
      scheduleElements.value[se.dayIndex + 7].add(se);
      totalTimes.value[se.dayIndex] += se.time;
      totalTimes.value[se.dayIndex + 7] += se.time;
      totalTimes.refresh();
      scheduleElements.refresh();
    } else if (se is ScheduleElementAssignment) {
      if (se.date?.year == 2100) {
        se.date = getDate(se);
        FirebaseFirestore.instance
            .collection('Schedule')
            .doc(se.docId)
            .update({"date": se.date});
      }

      int index = getDayIndex(se.date!);
      print(index);
      if (index != -1) {
        scheduleElements.value[index].add(se);
        totalTimes.value[index] += se.time;

        // print(totalTimes.value[4]);
      }

      totalTimes.refresh();
      addPrefix(se);
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
      if (se is ScheduleElementAssignment) {
        //!kasnije treba da se izmeni
        // removeFromScheduleElements(se1: se);
        //addInSchedule(se);
      }
    } else {
      addInSchedule(se);
    }
    scheduleElements.refresh();
  }

  DateTime getDate(ScheduleElementAssignment sea) {
    final days = daysBetween(DateTime.now(),
        /*sea.dueDate*/ DateTime.now().add(const Duration(days: 7)));
    List<int> times = [];
    final weekday = DateTime.now().weekday - 1;
    for (int i = weekday; i < days + weekday; i++) {
      if (i < 14) {
        if (breakday.breakdayIndex.value != -1 &&
            (i == breakday.breakdayIndex.value + 1 ||
                i == breakday.breakdayIndex.value + 1 + 7)) {
          times.add(100000);
        } else {
          times.add(totalTimes.value[i]);
        }
      } else {
        times.add(0);
      }
    }
    int index = minIndex(times);
    return DateUtils.dateOnly(DateTime.now().add(Duration(days: index)));
  }

  int minIndex(List<int> l) {
    int minel = 10000;
    int mini = 0;
    for (int i = 0; i < l.length; i++) {
      if (l[i] < minel) {
        minel = l[i];
        mini = i;
      }
    }
    return mini;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void updateIndex(ScheduleElement se, index) {
    if (se is ScheduleElementExtracurriculars) {}
  }

  void addPrefix(ScheduleElementAssignment se) {
    final f = scheduleElements.value
        .expand((element) => element)
        .whereType<ScheduleElementAssignment>()
        .toList();
    final list = f.where((element) => (element).parentId == se.parentId);
    for (var element in list) {
      element.pref = "Continue";
      element.color = list.first.color;
    }
    final first =
        f.firstWhereOrNull((element) => (element).parentId == se.parentId);
    first?.pref = "Start";

    final last = f.lastWhere(
      (element) => (element).parentId == se.parentId,
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
      await FirebaseFirestore.instance
          .collection('Schedule')
          .doc(scheduleElements.value[listIndex][i].docId)
          .update({"index": i});
    }
  }
}
