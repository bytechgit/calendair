import 'package:calendair/classes/authentication.dart';
import 'package:calendair/models/schedule/scheduleElement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<void> addInSchedule(
      {int? listIndex, int? index, UserAuthentication? ua}) async {
    if (listIndex != null && index != null) {
      dayIndex = listIndex % 7;
      if (index >= scheduleLists.scheduleElements.value[listIndex].length) {
        scheduleLists.scheduleElements.value[listIndex].add(this);
      } else {
        scheduleLists.scheduleElements.value[listIndex].insert(index, this);
      }
      if (index >=
          scheduleLists.scheduleElements.value[(listIndex + 7) % 14].length) {
        scheduleLists.scheduleElements.value[(listIndex + 7) % 14].add(this);
      } else {
        scheduleLists.scheduleElements.value[(listIndex + 7) % 14]
            .insert(index, this);
      }
      scheduleLists.addTimes(time, dayIndex);
      scheduleLists.addTimes(time, dayIndex + 7);
    } else {
      scheduleLists.addElement(this, dayIndex);
      scheduleLists.addElement(this, dayIndex + 7);
      scheduleLists.addTimes(time, dayIndex);
      scheduleLists.addTimes(time, dayIndex + 7);
    }
  }

  @override
  void modifieSchdeuleElement() {
    final res = scheduleLists.find(this);
    if (res != null) {
      if (dayIndex ==
          (res.element as ScheduleElementExtracurriculars).dayIndex) {
        scheduleLists.addTimes(time - res.element.time, dayIndex);
        scheduleLists.addTimes(time - res.element.time, dayIndex + 7);
        res.element.time = time;
        res.element.title = title;
        res.element.index = index;
        res.element.finished = finished;
        scheduleLists.refresh();
      } else {
        removeFromSchedule();
        addInSchedule();
      }
    } else {
      addInSchedule();
    }
  }

  @override
  void removeFromSchedule({int? listIndex, int? index}) {
    int lIndex = 0;
    int elIndex = 0;
    if (listIndex != null && index != null) {
      lIndex = listIndex;
      elIndex = index;
    } else {
      final res = scheduleLists.find(this);

      if (res == null) {
        return;
      }
      lIndex = res.listId;
      elIndex = res.elementId;
    }

    scheduleLists.scheduleElements.value[lIndex].removeAt(elIndex);
    int index2 = (lIndex + 7) % 14;
    scheduleLists.scheduleElements.value[index2]
        .removeWhere((element) => element.docId == docId);
    scheduleLists.addTimes(-time, lIndex);
    scheduleLists.addTimes(-time, index2);
    scheduleLists.scheduleElements.refresh();
  }

  @override
  void updateDate({required int newListIndex, required int oldListIndex}) {
    dayIndex = newListIndex % 7;
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(docId)
        .update({"dayIndex": dayIndex});
  }
}
