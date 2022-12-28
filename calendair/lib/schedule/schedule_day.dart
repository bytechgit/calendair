import 'package:calendair/schedule/assignment_element.dart';
import 'package:calendair/schedule/result.dart';
import 'package:calendair/schedule/schedule_element.dart';
import 'package:calendair/schedule/schedule_element_assignment.dart';
import 'package:calendair/schedule/schedule_element_extracurricular.dart';
import 'package:calendair/schedule/schedule_element_reminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleDay {
  List<ScheduleElement> elements = [];
  void add(ScheduleElement element) {
    int i = -1;
    if (element.index == 1000) {
      //nov
      if (elements is ScheduleElementReminder) {
        i = 0;
      } else if (element is ScheduleElementExtracurricular) {
        i = elements.length;
      } else if (element is ScheduleElementAssignment) {
        i = 0;
        while (i < elements.length && element is ScheduleElementReminder) {
          i++;
        }
      }
    } else {
      i = 0;
      while (i < elements.length &&
          (elements[i] is ScheduleElementReminder ||
              element.index > elements[i].index)) {
        i++;
      }
    }
    if (i != -1) {
      addAt(i, element);
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
          }
        }
      }
      return;
    }
    for (int i = 0; i < elements.length; i++) {
      if (elements[i].docId == element.docId) {
        removeAt(i);
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
        "color": element.color.value
      });
    } else if (element is ScheduleElementExtracurricular) {
      FirebaseFirestore.instance
          .collection('Extracurriculars')
          .doc(element.docId)
          .update({"index": element.index, "color": element.color.value});
    } else {
      FirebaseFirestore.instance
          .collection('Schedule')
          .doc(element.docId)
          .update({"index": element.index, "color": element.color.value});
    }
  }

  ScheduleElement? removeAt(int index) {
    if (index < 0 || index >= elements.length) {
      return null;
    }
    final element = elements.removeAt(index);
    for (int i = 0; i < elements.length; i++) {
      if (elements[i].index != i) {
        elements[i].index = i;
        // updateIndex(elements[i]);
      }
    }
    return element;
  }

  void addAt(int index, ScheduleElement element) {
    if (index < 0 || index > elements.length) {
      return;
    }
    elements.insert(index, element);
    for (int i = 0; i < elements.length; i++) {
      if (elements[i].index != i) {
        elements[i].index = i;
        // updateIndex(elements[i]);
      }
    }
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
