import 'dart:developer';

import 'package:calendair/models/schedule/scheduleElement.dart';
import 'package:calendair/models/schedule/scheduleElementReminder.dart';
import 'package:calendair/models/scheduleFindingResult.dart';
import 'package:get/get.dart';

import '../models/schedule/scheduleElementAssignment.dart';

class ScheduleLists extends GetxController {
  Map<String, dynamic>? timesList;
  final scheduleElements = Rx<List<List<ScheduleElement>>>(
      [[], [], [], [], [], [], [], [], [], [], [], [], [], []]);
  final totalTimes = Rx<List<int>>([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

  void addElement(ScheduleElement s, int index) {
    int i = 0;
    while (i < scheduleElements.value[index].length &&
        index >= scheduleElements.value[index][i].index) {
      i++;
    }
    if (i == scheduleElements.value[index].length) {
      scheduleElements.value[index].add(s);
    } else {
      scheduleElements.value[index].insert(i, s);
    }
  }

  Future<void> updateIndexes(int listIndex, int itemIndex) async {
    for (int i = 0; i < scheduleElements.value[listIndex].length; i++) {
      if (scheduleElements.value[listIndex][i] is! ScheduleElementReminder) {
        scheduleElements.value[listIndex][i].updateIndex(i);
      }
    }
  }

  @override
  void refresh() {
    super.refresh();
    scheduleElements.refresh();
    totalTimes.refresh();
  }

  void init() {
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
  }

  void addTimes(int time, int index) {
    totalTimes.value[index] += time;
  }

  FindingResult? find(ScheduleElement s) {
    for (int i = 0; i < scheduleElements.value.length; i++) {
      var list = scheduleElements.value[i];
      for (int j = 0; j < list.length; j++) {
        if (list[j].docId == s.docId) {
          return FindingResult(i, j, list[j]);
        }
      }
    }
    return null;
  }

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
    refresh();
  }
}
