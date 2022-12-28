import 'dart:async';
import 'package:calendair/controllers/schedule_algorithm.dart';
import 'package:calendair/schedule/assignment_element.dart';
import 'package:calendair/schedule/result.dart';
import 'package:calendair/schedule/schedule_day.dart';
import 'package:calendair/schedule/schedule_element.dart';
import 'package:calendair/schedule/schedule_element_assignment.dart';
import 'package:calendair/schedule/schedule_element_extracurricular.dart';
import 'package:calendair/schedule/schedule_element_reminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleController extends ChangeNotifier {
  List<ScheduleElementExtracurricular> extracurriculars = [];
  ScheduleAlgorithm scheduleAlgorithm = ScheduleAlgorithm();
  void addExtracurricular(ScheduleElementExtracurricular extracurricular) {
    extracurriculars.add(extracurricular);
    addInSchedule(extracurricular);
    notifyListeners();
  }

  void editExtracurricular(ScheduleElementExtracurricular extracurricular) {
    modifyScheduleElement(extracurricular);
    notifyListeners();
  }

  void addExtracurriculars(
      List<ScheduleElementExtracurricular> extracurriculars) {
    this.extracurriculars = extracurriculars;
    notifyListeners();
  }

  void deleteExtracurricular(ScheduleElementExtracurricular extracurricular) {
    extracurriculars.remove(extracurricular);
    removeFromSchedule(extracurricular);
    notifyListeners();
  }

  List<ScheduleDay> days = List.generate(14, (index) => ScheduleDay());
  StreamSubscription? scheduleSubscription;
  StreamSubscription? reminderSubscription;
  StreamSubscription? assignmentSupscription;
  StreamSubscription? extracurricularSubscription;
  void cancel() {
    scheduleSubscription?.cancel();
  }

  void listen(String uid) {
    for (var element in extracurriculars) {
      addInSchedule(element);
    }
    DateTime dtn = DateTime.now();
    final nd = dtn.weekday;
    final startDate = DateUtils.dateOnly(dtn.subtract(Duration(days: nd - 1)));
    final endDate = DateUtils.dateOnly(startDate.add(const Duration(days: 13)));
    cancel();
    scheduleSubscription = FirebaseFirestore.instance
        .collection('Schedule')
        .where("studentId", isEqualTo: uid)
        .where("dueDate", isGreaterThanOrEqualTo: startDate)
        .where("dueDate", isLessThanOrEqualTo: endDate)
        .orderBy("dueDate")
        .orderBy("index")
        .snapshots()
        .listen((e) {
      final List<AssignmentElement> newAssignmets = [];
      ScheduleElement? el;
      for (var element in e.docChanges) {
        print((element.doc.data()!));
        if (element.doc.data() == null) {
          continue;
        }
        if (element.doc.data()!['type'] == "assignment") {
          el = AssignmentElement.fromMap(
              map: element.doc.data()!,
              docId: element.doc.id,
              changeType: element.type);
          if ((el as AssignmentElement).dates.isEmpty) {
            newAssignmets.add(el);
            continue;
          }
        } else if (element.doc.data()!['type'] == "reminder") {
          el = ScheduleElementReminder.fromMap(
              map: element.doc.data()!,
              docId: element.doc.id,
              changeType: element.type);
        }
        if (el != null) {
          if (el.changeType == DocumentChangeType.added) {
            addInSchedule(el);
          } else if (el.changeType == DocumentChangeType.modified) {
            modifyScheduleElement(el);
          } else if (el.changeType == DocumentChangeType.removed) {
            removeElement(el);
          }
        }
      }
      for (var element in newAssignmets) {
        if (element.changeType == DocumentChangeType.added) {
          addInSchedule(element);
        } else if (element.changeType == DocumentChangeType.modified) {
          modifyScheduleElement(element);
        } else if (element.changeType == DocumentChangeType.removed) {
          removeElement(element);
        }
      }
    });
  }

  void addInSchedule(ScheduleElement element) async {
    if (element is ScheduleElementReminder) {
      if (element.dayIndex != -1) {
        days[element.dayIndex].add(element);
      }
    } else if (element is ScheduleElementExtracurricular) {
      days[element.day].add(element);
      days[element.day + 7].add(element);
    } else if (element is AssignmentElement) {
      if (element.dates.isEmpty) {
        final dtn = DateTime.now();
        final nd = dtn.weekday;
        final startDate =
            DateUtils.dateOnly(dtn.subtract(Duration(days: nd - 1)));
        int difference = element.dueDate.difference(startDate).inDays;
        List<int> times = [];
        for (int i = nd - 1; i <= difference; i++) {
          times.add(days[i].time);
        }
        final newTimes = scheduleAlgorithm.startScheduling(
            initTimes: times, newClassDuration: element.duration);
        for (int i = 0; i < newTimes.length; i++) {
          if (newTimes[i] != 0) {
            element.dates.add(dtn.add(Duration(days: i)));
            element.times.add(newTimes[i]);
            element.indexes.add(1000);
            element.remainingTimes.add(newTimes[i] * 60);
          }
        }
        FirebaseFirestore.instance
            .collection('Schedule')
            .doc(element.docId)
            .update(element.toMap());
      }
      ScheduleElementAssignment? assignment;
      for (int i = 0; i < element.dates.length; i++) {
        assignment =
            ScheduleElementAssignment(positionIndex: i, assignmentRef: element);
        if (assignment.dayIndex != -1) {
          days[assignment.dayIndex].add(assignment);
        }
      }
      if (assignment != null) {
        addPrefix(assignment);
      }
    } else if (element is ScheduleElementAssignment) {
      if (element.dayIndex != -1) {
        days[element.dayIndex].add(element);
      }
    }
    notifyListeners();
  }

  void removeFromSchedule(ScheduleElement element) {
    if (element is ScheduleElementReminder) {
      days[element.dayIndex].remove(element);
    } else if (element is ScheduleElementExtracurricular) {
      days[element.day].remove(element);
      days[element.day + 7].remove(element);
    } else if (element is AssignmentElement) {
      removeElement(element);
    } else if (element is ScheduleElementAssignment) {
      days[element.dayIndex].remove(element);
    }
    notifyListeners();
  }

  void modifyScheduleElement(ScheduleElement element) {
    final result = find(element);
    if (result == null) {
      removeElement(element);
      addInSchedule(element);
      return;
    }
    if (element is AssignmentElement) {
      final assignment =
          (result.element as ScheduleElementAssignment).assignmentRef;

      int timeDifference = element.duration - assignment.duration;
      if (timeDifference < 0) {
        //ako je smanjeno vreme
        int i = assignment.dates.length - 1;
        while (timeDifference < 0) {
          if (timeDifference.abs() >= assignment.times[i]) {
            element.dates.removeLast();
            final time = element.times.removeLast();
            element.indexes.removeLast();
            element.remainingTimes.removeLast();
            timeDifference += time;
          } else {
            element.times[i] -= timeDifference.abs();
            element.remainingTimes[i] -= timeDifference.abs();
            if (element.remainingTimes[i] < 0) {
              element.remainingTimes[i] = 0;
            }
            timeDifference = 0;
          }
          i--;
        }
        FirebaseFirestore.instance
            .collection('Schedule')
            .doc(element.docId)
            .update(element.toMap());
      } else if (timeDifference > 0) {
        final dtn = DateTime.now();
        final nd = dtn.weekday;
        final startDate =
            DateUtils.dateOnly(dtn.subtract(Duration(days: nd - 1)));
        int difference = element.dueDate.difference(startDate).inDays;
        List<int> times = [];
        List<int> startTimes = [];
        for (int i = nd - 1; i <= difference; i++) {
          times.add(days[i].time);
          startTimes.add(days[i].getAssignmetTime(element));
        }
        final newTimes = scheduleAlgorithm.startScheduling(
            initTimes: times,
            newClassDuration: timeDifference,
            startTimes: startTimes);

        for (int i = 0; i < newTimes.length; i++) {
          newTimes[i] -= startTimes[i];
        }
        for (int i = 0; i < newTimes.length; i++) {
          if (newTimes[i] != 0) {
            if (startTimes[i] != 0) {
              final res = days[i + nd - 1].find(element);
              if (res != null) {
                element.times[(res.element as ScheduleElementAssignment)
                    .positionIndex] += newTimes[i];
                element.remainingTimes[
                    (res.element as ScheduleElementAssignment)
                        .positionIndex] += newTimes[i];
              }
            } else {
              element.dates.add(dtn.add(Duration(days: i)));
              element.times.add(newTimes[i]);
              element.indexes.add(1000);
              element.remainingTimes.add(newTimes[i] * 60);
            }
          }
        }
        FirebaseFirestore.instance
            .collection('Schedule')
            .doc(element.docId)
            .update(element.toMap());
      }
      removeElement(element);
      addInSchedule(element);
      return;
    }

    if (element is ScheduleElementExtracurricular) {
      days[result.listIndex].removeAt(result.index);
      days[(result.listIndex + 7 % 14)].remove(element);
      addInSchedule(element);
    } else if (element is ScheduleElementReminder) {
      if (!element.date
          .isAtSameMomentAs((result.element as ScheduleElementReminder).date)) {
        days[result.listIndex].removeAt(result.index);
        addInSchedule(element);
      } else {
        (result.element as ScheduleElementReminder).title = element.title;
      }
    }
    notifyListeners();
  }

  void removeElement(ScheduleElement element) {
    for (int i = 0; i < 14; i++) {
      days[i].remove(element);
    }
  }

  void itemReorder(
      {required int oldListIndex,
      required int newListIndex,
      required int oldItemIndex,
      required int newItemIndex}) {
    if (oldListIndex < 0 ||
        oldListIndex >= days.length ||
        newListIndex < 0 ||
        newListIndex >= days.length) {
      return;
    }
    final element = days[oldListIndex].getElement(oldItemIndex);
    if (element == null) {
      return;
    }
    if (element is ScheduleElementAssignment) {
      if (DateUtils.dateOnly(
                  element.date.add(Duration(days: newListIndex - oldListIndex)))
              .compareTo(DateUtils.dateOnly(element.assignmentRef.dueDate)) >
          0) {
        //assignment ne moze da se pomeri iza dueDate
        return;
      }
    }

    if (oldListIndex < 7 && newListIndex >= 7 ||
        oldListIndex >= 7 && newListIndex < 7) {
      if (element is ScheduleElementExtracurricular) {
        //ako je extracurriculars ne moze da se pomeri u sledecu nedeljeu
        return;
      }
    }
//remove deo
    if (days[oldListIndex].removeAt(oldItemIndex) == null) {
      return;
    }
    if (element is ScheduleElementExtracurricular) {
      int listindex1 = (oldListIndex + 7) % 14;
      days[listindex1].remove(element);
    }
//remove

//add deo
    if (oldListIndex != newListIndex) {
      updateDate(
        element: element,
        days: newListIndex - oldListIndex,
      );
    }
    if (element is ScheduleElementExtracurricular) {
      days[(newListIndex + 7) % 14].add(element);
    }
    if (element is ScheduleElementReminder) {
      days[newListIndex].addAt(0, element);
      return;
    }

    days[newListIndex].add(element);
    if (element is ScheduleElementAssignment) {
      addPrefix(element);
    }
    notifyListeners();
//add
  }

  Result? find(ScheduleElement element) {
    for (int i = 0; i < days.length; i++) {
      final el = days[i].find(element);
      if (el != null) {
        el.listIndex = i;
        return el;
      }
    }
    return null;
  }

  void addPrefix(ScheduleElementAssignment se) {
    final assignments = days
        .map((e) => e.elements)
        .expand((element) => element)
        .whereType<ScheduleElementAssignment>()
        .where(
            (element) => element.assignmentRef.docId == se.assignmentRef.docId)
        .toList();

    for (var element in assignments) {
      element.prefix = "Continue";
    }
    if (assignments.isNotEmpty) {
      assignments[0].prefix = "Start";
    }
    if (assignments.length > 1) {
      assignments[assignments.length - 1].prefix = "Finish";
    }
  }

  void updateDate({
    required ScheduleElement element,
    required int days,
  }) {
    final doc =
        FirebaseFirestore.instance.collection('Schedule').doc(element.docId);
    if (element is ScheduleElementReminder) {
      element.date = element.date.add(Duration(days: days));
      doc.update({
        "dueDate": element.date,
      });
    } else if (element is ScheduleElementExtracurricular) {
      element.day += days;
      FirebaseFirestore.instance
          .collection('Extracurriculars')
          .doc(element.docId)
          .update({
        "day": element.day,
      });
    } else if (element is ScheduleElementAssignment) {
      element.date = element.date.add(Duration(days: days));
      doc.update({
        "dates": element.assignmentRef.dates,
      });
    }
  }
}
