import 'dart:async';

import 'package:calendair/classes/scheduleLists.dart';
import 'package:calendair/models/schedule/ScheduleElementExtracurriculars.dart';
import 'package:calendair/models/schedule/scheduleElement.dart';
import 'package:calendair/models/schedule/scheduleElementAssignment.dart';
import 'package:calendair/models/schedule/scheduleElementAssignmentMain.dart';
import 'package:calendair/models/schedule/scheduleElementReminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  StreamSubscription? streamSubscription;
  final scheduleLists = Get.find<ScheduleLists>();
  Map<String, dynamic>? times;

  void listen(String uid) {
    scheduleLists.init();
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
            se.addInSchedule();
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
      scheduleLists.addPrefix(se);
    }
    scheduleLists.updateIndexes(newListIndex, index);
  }

  ScheduleElement removeFromScheduleElements(
      {required int listIndex, required int index}) {
    final el = scheduleLists.scheduleElements.value[listIndex][index];
    el.removeFromSchedule(listIndex: listIndex, index: index);
    return el;
  }
}
