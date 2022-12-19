import 'dart:async';
import 'package:calendair/classes/authentication.dart';
import 'package:calendair/models/schedule/ScheduleElementExtracurriculars.dart';
import 'package:calendair/models/schedule/scheduleElement.dart';
import 'package:calendair/models/schedule/scheduleElementAssignment.dart';
import 'package:calendair/models/schedule/scheduleElementAssignmentMain.dart';
import 'package:calendair/models/schedule/scheduleElementReminder.dart';
import 'package:calendair/models/scheduleFindingResult.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ScheduleController {
  StreamSubscription? streamSubscription;
  Map<String, dynamic>? times;
  UserAuthentication userAuthentication;
  ScheduleController(this.userAuthentication);
  void listen(String uid) {
    streamSubscription?.cancel();
    streamSubscription = FirebaseFirestore.instance
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
            se.addInSchedule(ua: userAuthentication);
          } else if (doc.type == DocumentChangeType.modified) {
            se.modifieSchdeuleElement();
          } else if (doc.type == DocumentChangeType.removed) {
            se.removeFromSchedule();
          }
        }
      }
    });
  }

  void addInScheduleElements({
    required int oldListIndex,
    required int newListIndex,
    required ScheduleElement se,
    required int index,
  }) {
    if (oldListIndex != newListIndex) {
      se.updateDate(newListIndex: newListIndex, oldListIndex: oldListIndex);
    }
    // if (se is! ScheduleElementReminder) {
    //   se.index = index;
    // }
    se.addInSchedule(listIndex: newListIndex, index: index);
    if (se is ScheduleElementAssignment) {
      addPrefix(se);
    }
    updateIndexes(newListIndex, index);
  }

  ScheduleElement removeFromScheduleElements(
      {required int listIndex, required int index}) {
    final el = scheduleElements[listIndex][index];
    el.removeFromSchedule(listIndex: listIndex, index: index);
    return el;
  }

  ////
  ///
  List<List<ScheduleElement>> scheduleElements = [
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
  List<int> totalTimes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  void addElement(ScheduleElement s, int index) {
    int i = 0;
    while (i < scheduleElements[index].length &&
        index >= scheduleElements[index][i].index) {
      i++;
    }
    if (i == scheduleElements[index].length) {
      scheduleElements[index].add(s);
    } else {
      scheduleElements[index].insert(i, s);
    }
  }

  Future<void> updateIndexes(int listIndex, int itemIndex) async {
    for (int i = 0; i < scheduleElements[listIndex].length; i++) {
      if (scheduleElements[listIndex][i] is! ScheduleElementReminder) {
        scheduleElements[listIndex][i].updateIndex(i);
      }
    }
  }

  // void addTimes(int time, int index) {
  //   totalTimes.value[index] += time;
  // }

  FindingResult? find(ScheduleElement s) {
    for (int i = 0; i < scheduleElements.length; i++) {
      var list = scheduleElements[i];
      for (int j = 0; j < list.length; j++) {
        if (list[j].docId == s.docId) {
          return FindingResult(i, j, list[j]);
        }
      }
    }
    return null;
  }

  void addPrefix(ScheduleElementAssignment se) {
    final f = scheduleElements
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
  }

  bool breakDayIsEmpty(int index) {
    print(index);
    if (scheduleElements[index].isNotEmpty ||
        scheduleElements[index + 7].isNotEmpty) {
      print("false");
      return false;
    }
    print("true");
    return true;
  }
}
