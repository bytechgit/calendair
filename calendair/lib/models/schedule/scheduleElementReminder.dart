import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/models/schedule/scheduleElement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleElementReminder extends ScheduleElement {
  @override
  void addInSchedule({int? listIndex, int? index, FirebaseController? ua}) {
    index = getDayIndex();
    if (index != -1) {
      if (ua!.currentUser?.breakday == index) {
        index += 1;
      }
      scheduleLists.scheduleElements.value[index].insert(0, this);
    }
  }

  @override
  void modifieSchdeuleElement() {
    final res = scheduleLists.find(this);
    if (res != null) {
      if (res.element.date == null || date == null) {
        return;
      }
      if (date!.isAtSameMomentAs(res.element.date!)) {
        res.element.finished = finished;
        res.element.time = time;
        res.element.title = title;
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
    if (listIndex != null && index != null) {
      scheduleLists.scheduleElements.value[listIndex].removeAt(index);
      scheduleLists.scheduleElements.refresh();
    } else {
      final res = scheduleLists.find(this);
      if (res == null) {
        return;
      }
      scheduleLists.scheduleElements.value[res.listId].removeAt(res.elementId);
      scheduleLists.scheduleElements.refresh();
    }
  }

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
