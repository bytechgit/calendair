import 'package:calendair/schedule/assignment_element.dart';
import 'package:calendair/schedule/result.dart';
import 'package:calendair/schedule/schedule_element.dart';
import 'package:calendair/schedule/schedule_element_assignment.dart';
import 'package:calendair/schedule/schedule_element_extracurricular.dart';
import 'package:calendair/schedule/schedule_element_reminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleDay {
  int _weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  int get week {
    return _weeksBetween(DateTime.utc(date.year, 1, 1), date);
  }

  List<ScheduleElement> elements = [];
  DateTime date;
  ScheduleDay({required this.date});
  void add({required ScheduleElement element, bool? update}) {
    int i = -1;
    if (element.getIndex(week: week) == 0x7fffffff) {
      //novi
      if (element is ScheduleElementReminder) {
        i = 0;
      } else if (element is ScheduleElementExtracurricular) {
        i = elements.length;
      } else if (element is ScheduleElementAssignment) {
        i = 0;
        while (
            i < elements.length && (elements[i] is ScheduleElementReminder)) {
          i++;
        }
      }
      addAt(i, element, true);
    } else {
      i = 0;
      while (i < elements.length &&
          ((elements[i] is ScheduleElementReminder) ||
              element.getIndex(week: week) >
                  elements[i].getIndex(week: week))) {
        i++;
      }
      addAt(i, element, update ?? false);
    }
  }

  int getAssignmetTime(AssignmentElement assignment) {
    return elements.fold<int>(0, (previousValue, element) {
      if (element.docId == assignment.docId) {
        return previousValue + element.duration;
      }
      return previousValue;
    });
  }

  void remove(ScheduleElement element) {
    if (element is ScheduleElementAssignment) {
      for (int i = 0; i < elements.length; i++) {
        if (elements[i] is ScheduleElementAssignment) {
          if (elements[i].docId == element.docId &&
              (elements[i] as ScheduleElementAssignment).positionIndex ==
                  element.positionIndex) {
            removeAt(i);
            i--;
          }
        }
      }
      return;
    }
    for (int i = 0; i < elements.length; i++) {
      if (elements[i].docId == element.docId) {
        removeAt(i);
        i--;
      }
    }
  }

  int get time {
    return elements.fold(0, (previousValue, element) {
      return previousValue + element.duration;
    });
  }

  void updateIndex(ScheduleElement element) {
    if (element is ScheduleElementAssignment) {
      FirebaseFirestore.instance
          .collection('Schedule')
          .doc(element.docId)
          .update({
        "indexes": (element).assignmentRef.indexes,
        "index": 0,
        "color": element.color.value,
        "dates": element.assignmentRef.dates
      });
    } else if (element is ScheduleElementExtracurricular) {
      FirebaseFirestore.instance
          .collection('Extracurriculars')
          .doc(element.docId)
          .update({
        "indexes": element.indexes,
        "color": element.color.value,
        "day": element.day
      });
    } else if (element is ScheduleElementReminder) {
      FirebaseFirestore.instance
          .collection('Schedule')
          .doc(element.docId)
          .update({
        "index": element.getIndex(week: week),
        "color": element.color.value,
        "date": element.date
      });
    }
  }

  ScheduleElement? removeAt(int index) {
    if (index < 0 || index >= elements.length) {
      return null;
    }
    final element = elements.removeAt(index);
    return element;
  }

  void addAt(int index, ScheduleElement element, bool update) {
    if (index < 0 || index > elements.length) {
      return;
    }
    elements.insert(index, element);
    if (!update) {
      return;
    }
    final prev = getElement(index - 1);
    final next = getElement(index + 1);
    if (prev == null && next == null) {
      //ako je jedini u listi
      element.setIndex(index: 0, week: week);
    } else if (prev == null && next != null) {
      //ako je prvi u listi
      element.setIndex(index: next.getIndex(week: week) - 100000, week: week);
    } else if (prev != null && next == null) {
      //ako je zadnji u listi
      element.setIndex(index: prev.getIndex(week: week) + 100000, week: week);
    } else {
      //ako je izmedju
      element.setIndex(
          index:
              ((prev!.getIndex(week: week) + next!.getIndex(week: week)) ~/ 2),
          week: week);
    }
    updateIndex(element);
  }

  Result? find(ScheduleElement element) {
    if (element is ScheduleElementAssignment) {
      for (int i = 0; i < elements.length; i++) {
        if (elements[i] is ScheduleElementAssignment) {
          if (elements[i].docId == element.docId &&
              (elements[i] as ScheduleElementAssignment).positionIndex ==
                  element.positionIndex) {
            return Result(listIndex: -1, index: i, element: elements[i]);
          }
        }
      }
      return null;
    }
    for (int i = 0; i < elements.length; i++) {
      if (elements[i].docId == element.docId) {
        return Result(listIndex: -1, index: i, element: elements[i]);
      }
    }
    return null;
  }

  ScheduleElement? getElement(int i) {
    if (i < 0 || i >= elements.length) {
      return null;
    }
    return elements[i];
  }
}
