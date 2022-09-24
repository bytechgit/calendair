import 'package:calendair/models/schedule/scheduleElementAssignmentMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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
            indexes: m.indexes,
            remainingTimes: m.remainingTimes) {
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
  Future<void> addInSchedule({int? listIndex, int? index}) async {
    if (listIndex != null && index != null) {
      scheduleLists.scheduleElements.value[listIndex].insert(index, this);
      scheduleLists.addTimes(time, listIndex);
    } else {
      int lIndex = getDayIndex();
      if (lIndex != -1) {
        scheduleLists.addElement(this, lIndex);
        scheduleLists.addTimes(time, lIndex);
      }
    }
  }

  @override
  void removeFromSchedule({int? listIndex, int? index}) {
    if (listIndex != null && index != null) {
      scheduleLists.scheduleElements.value[listIndex].removeAt(index);
      scheduleLists.addTimes(-time, listIndex);
    } else {
      final res = scheduleLists.find(this);
      //!treba se ispravi
      if (res == null) {
        return;
      }
      scheduleLists.scheduleElements.value[res.listId].removeAt(res.elementId);
      scheduleLists.addTimes(-time, res.listId);
    }
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
  void finish(bool f, {int? time}) {
    finished = f;
    finishedList[i] = f;
    if (time != null) {
      remainingTimes[i] = time;
    } else {
      remainingTimes[i] = f ? 0 : this.time;
    }
    FirebaseFirestore.instance.collection('Schedule').doc(docId).update(
        {"finishedList": finishedList, "remainingTimes": remainingTimes});
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
      // 'finishedList': finishedList,
      //'indexes': indexes,
      //'dates': dates,
      //'times': times,
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
      : super.fromMap(map, docId) {
    timesec = map["timesec"] ?? 0;
  }
}
