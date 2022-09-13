/*
notifications
da se pamti redosled u toku dana
bag sa editovanje extra, ne setuje dan inicijanlo na pravi.
da se napravi stranica za samododavanje remindera

sta ne moze
ne mogu da se fiksiraju dole reminderi jer je to skrol
ne mogu da se pomeraju reminderi
Kad dodajes extracurriculars dani idu krenuvsi od danas
da li da delimo assignment.
velika je verovatnoca da ce da se prebaci za sledecu nedelju 
Da li je bitan redosled u toku dana?
 */
///////////////////////////////////
import 'dart:developer';

import 'package:calendair/classes.dart';
import 'package:calendair/models/AssignmentModel.dart';
import 'package:calendair/models/ExtracurricularsModel.dart';
import 'package:calendair/models/ScheduleElementModel.dart';
import 'package:calendair/models/UserModel.dart';
import 'package:calendair/models/reminderModel.dart';
import 'package:calendair/models/scheduleFindingResult.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:sqflite/utils/utils.dart';
import 'Authentication.dart';
import 'googleClassroom.dart';
import 'package:intl/intl.dart';

class Firestore {
  static final Firestore _singleton = Firestore._internal();
  final ua = UserAuthentication();
  final gc = Get.find<GoogleClassroom>();

  factory Firestore() {
    return _singleton;
  }

  final firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference courses =
      FirebaseFirestore.instance.collection('Courses');
  CollectionReference popups = FirebaseFirestore.instance.collection('Popups');
  CollectionReference reminder =
      FirebaseFirestore.instance.collection('Reminders');

  Firestore._internal() {
    _initializeFirebase();
  }

  bool isInRange(DateTime start, DateTime date, DateTime end) {
    start.subtract(Duration(
        minutes: start.minute,
        seconds: start.second,
        milliseconds: start.millisecond,
        microseconds: start.microsecond));
    end.subtract(Duration(
        minutes: end.minute,
        seconds: end.second,
        milliseconds: end.millisecond,
        microseconds: end.microsecond));
    return date.isAfter(start) && date.isBefore(end);
  }

  int getDayIndex(DateTime dt) {
    DateTime dtn = DateTime.now();
    final nd = dtn.weekday;
    final startDate = dtn.subtract(Duration(days: nd - 1));
    final endDate = startDate.add(const Duration(days: 7));
    if (isInRange(startDate, dt, endDate)) {
      return dt.day - startDate.day;
    } else {
      return -1;
    }
  }

  FindingResult? findScheduleElement(ScheduleElement sc) {
    for (int i = 0; i < gc.scheduleElements.value.length; i++) {
      var list = gc.scheduleElements.value[i];
      for (int j = 0; j < list.length; j++) {
        if (list[j].docId == sc.docId) {
          return FindingResult(i, j, list[j]);
        }
      }
    }
    return null;
  }

  bool addInSchedule(ScheduleElement se) {
    if (se.type == "assignment" && se.date == null) {
      se.date = DateTime.now();

      updateScheduleElementDate(se);
      print("OVDEEEEE");
    }
    int index = getDayIndex(se.date!);
    if (index != -1) {
      se.setRandomColor(gc.scheduleElements.value[index].length > 0
          ? gc.scheduleElements.value[index].last.colorIndex
          : null);
      gc.addInScheduleElements(day: index, se: se);
      //gc.scheduleElements.value[index].add(se);
      gc.scheduleElements.refresh();
      return true;
    }
    return false;
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    listenReminders().listen((e) {
      for (var doc in e.docChanges) {
        final ScheduleElement se = ScheduleElement.fromMap(
          doc.doc.data()!,
          doc.doc.id,
          "reminder",
        );
        if (doc.type == DocumentChangeType.modified) {
          var fse = findScheduleElement(se);
          if (fse != null) {
            if (fse.element.date!.isAtSameMomentAs(se.date!)) {
              fse.element.title = se.title;
            } else {
              gc.removeFromScheduleElements(day: fse.dayId, index: fse.classId);
              //gc.scheduleElements.value[fse.dayId].removeAt(fse.classId);
              addInSchedule(se);
            }
            gc.scheduleElements.refresh();
          } else {
            addInSchedule(se);
          }
        }
        if (doc.type == DocumentChangeType.added) {
          addInSchedule(se);
          // gc.scheduleElements.refresh();
        }
        if (doc.type == DocumentChangeType.removed) {
          var fse = findScheduleElement(se);
          if (fse != null) {
            gc.removeFromScheduleElements(day: fse.dayId, index: fse.classId);
            // gc.scheduleElements.value[fse.dayId].removeAt(fse.classId);
            gc.scheduleElements.refresh();
          }
        }
      }
    });

    listenExtracurriculars().listen((e) {
      for (var doc in e.docChanges) {
        final ScheduleElement se = ScheduleElement.fromMap(
            doc.doc.data()!, doc.doc.id, "extracurriculars");

        if (doc.type == DocumentChangeType.added) {
          addInSchedule(se);
        }
        if (doc.type == DocumentChangeType.modified) {
          var fse = findScheduleElement(se);
          if (fse != null) {
            if (fse.element.date!.isAtSameMomentAs(se.date!)) {
              fse.element.title = se.title;
              fse.element.time = se.time;
              print("UPDATEEEEE");
            } else {
              gc.removeFromScheduleElements(day: fse.dayId, index: fse.classId);
              // gc.scheduleElements.value[fse.dayId].removeAt(fse.classId);
              addInSchedule(se);
              print("REMOVEEEEE");
            }
            gc.scheduleElements.refresh();
          } else {
            addInSchedule(se);
          }
        }
        if (doc.type == DocumentChangeType.removed) {
          var fse = findScheduleElement(se);
          if (fse != null) {
            gc.removeFromScheduleElements(day: fse.dayId, index: fse.classId);
            // gc.scheduleElements.value[fse.dayId].removeAt(fse.classId);
            gc.scheduleElements.refresh();
          }
        }
      }
    });

    listenStudentAssigments().listen((e) async {
      for (var doc in e.docChanges) {
        ScheduleElement se =
            ScheduleElement.fromMap(doc.doc.data()!, doc.doc.id, "assignment");
        MyAssignment mya = await readMyAssignmentById(se.parentDocRef!);
        se.time = mya.duration;
        se.note = mya.note!;
        se.dueDate = mya.dueDate;
        se.title = mya.title;

        if (doc.type == DocumentChangeType.added) {
          addInSchedule(se);
        }
        if (doc.type == DocumentChangeType.modified) {
          var fse = findScheduleElement(se);
          if (fse != null) {
            if (fse.element.date!.isAtSameMomentAs(se.date!)) {
              fse.element.time = se.time;
              fse.element.note = se.note;
            } else {
              gc.removeFromScheduleElements(day: fse.dayId, index: fse.classId);
              //gc.scheduleElements.value[fse.dayId].removeAt(fse.classId);
              addInSchedule(se);
            }
            gc.scheduleElements.refresh();
          } else {
            addInSchedule(se);
          }
        }
      }
    });

    return firebaseApp;
  }

  void updateScheduleElementDate(ScheduleElement se) {
    print(se.type);
    if (se.type == "assignment") {
      print("ASSSIGNMENT");

      FirebaseFirestore.instance
          .collection('ScheduleAssignments')
          .doc(se.docId)
          .update({
        "date": se.date,
      });
    } else if (se.type == "extracurriculars") {
      FirebaseFirestore.instance
          .collection('Extracurriculars')
          .doc(se.docId)
          .update({
        "date": se.date,
      });
    }
  }

  void addUserIfNotExist({required UserModel user}) {
    users.doc(user.id).get().then((DocumentSnapshot ds) {
      if (!ds.exists) {
        users.doc(user.id).set({
          "courses": [],
          "type": user.type,
          "name": user.name,
          "picture": user.picture,
        }, SetOptions(merge: true));
      }
    });
  }

  Future<String> getUserIfExist(String UID) async {
    final ds = await users.doc(UID).get();
    if (ds.exists) {
      return ds["type"];
    }
    return "";
  }

  Future<void> addPopUp(
      {required String classId,
      required DateTime date,
      required String title,
      required String cm}) async {
    popups.add({
      "class": classId,
      "dueDate": date,
      "title": title,
      "numRate": 0,
      "sumRate": 0,
      "question": cm,
      "order": DateTime.now(),
      "students": ((await courses.doc(classId).get()).data()!
              as Map<String, dynamic>)["students"] ??
          []
    });
  }

  Future<void> addReminder(
      {required String classId,
      required DateTime date,
      required String title}) async {
    reminder.add({
      "class": classId,
      "date": date,
      "title": title,
      "students": ((await courses.doc(classId).get()).data()!
              as Map<String, dynamic>)["students"] ??
          []
    });
  }

  void updateReminder({required ReminderModel r}) {
    reminder.doc(r.id).update({
      "title": r.title,
      "date": r.date,
    });
  }

  void addCourse({
    required String classId,
    required String code,
    required String name,
  }) {
    FirebaseFirestore.instance.collection('Courses').add({
      "id": classId,
      "code": code,
      "name": name,
      "owner": ua.currentUser!.uid,
      "students": []
    });
    addCourseToUser(classId);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTeacherCourses() {
    return FirebaseFirestore.instance
        .collection('Courses')
        .where("owner", isEqualTo: ua.currentUser!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getExtracurriculars() {
    return FirebaseFirestore.instance
        .collection('Extracurriculars')
        .where("studentId", isEqualTo: ua.currentUser!.uid)
        .where("date",
            isGreaterThanOrEqualTo: Timestamp.fromDate(
                DateTime.now().subtract(const Duration(days: 8))))
        .orderBy("date", descending: true)
        .snapshots();
  }

  void updateExtracurriculars(ExtracurricularsModel ex) {
    FirebaseFirestore.instance
        .collection('Extracurriculars')
        .doc(ex.id)
        .update(ex.toMap());
  }

  void addBreakDay(String day) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(ua.currentUser!.uid)
        .update({"breakday": day});
  }

  Future<String> getBreakday() async {
    return (await FirebaseFirestore.instance
            .collection('Users')
            .doc(ua.currentUser!.uid)
            .get())
        .data()!["breakday"];
  }

  void addExtracurriculars(int time, String title, String day, DateTime date) {
    FirebaseFirestore.instance.collection('Extracurriculars').add({
      "title": title,
      "day": day,
      "time": time,
      "date": Timestamp.fromDate(date),
      "studentId": ua.currentUser!.uid
    });
  }

  Future<void> insertAssignmentCopyForStudents(
      MyAssignment mya, String courseId) async {
    print("EVOOOOOOOOOOOO");
    //await gc.getStudentsList(mya.coursework!.courseId!);
    QuerySnapshot<Map<String, dynamic>> students =
        await getStudentsFromCourse(courseId);
    for (var student in students.docs) {
      print(student.id);
      FirebaseFirestore.instance.collection('ScheduleAssignments').add({
        "studentId": student.id,
        //   "note": mya.note,
        //    "duration": mya.duration,
        "parentDocRef": "${mya.coursework!.courseId!}${mya.coursework!.id!}"
      });
    }
  }

  Future<void> insertOrUpdateAssignment(
      MyAssignment mya, String courseId) async {
    FirebaseFirestore.instance
        .collection('Assignments')
        .doc(mya.coursework!.courseId! + mya.coursework!.id!)
        .get()
        .then((DocumentSnapshot ds) {
      if (!ds.exists) {
        //insert
        FirebaseFirestore.instance
            .collection('Assignments')
            .doc(mya.coursework!.courseId! + mya.coursework!.id!)
            .set({
          "note": mya.note,
          "duration": mya.duration,
          "dueDate": mya.coursework!.dueDate ??
              DateTime.now().add(const Duration(days: 7)),
          "title": mya.coursework!.title
        }, SetOptions(merge: true));
        insertAssignmentCopyForStudents(mya, courseId);
      } else //update
      {
        FirebaseFirestore.instance
            .collection('Assignments')
            .doc(mya.coursework!.courseId! + mya.coursework!.id!)
            .update({
          "note": mya.note,
          "duration": mya.duration,
          "dueDate": mya.coursework!.dueDate ??
              DateTime.now().add(const Duration(days: 7))
        });
      }
    });
  }

  Future<MyAssignment> readMyAssignment(CourseWork cw) async {
    return readMyAssignmentById(cw.courseId! + cw.id!);
  }

  Future<MyAssignment> readMyAssignmentById(String id) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('Assignments')
        .doc(id)
        .get();
    if (ds.exists) {
      print("OVDEE postoji");
      return MyAssignment.fromMap(ds.data() as Map<String, dynamic>, null);
    } else {
      print("OVDEE ne postoji");
      return MyAssignment(null, 0, null);
    }
  }

  void deleteExtracurriculars(ExtracurricularsModel ex) {
    FirebaseFirestore.instance
        .collection('Extracurriculars')
        .doc(ex.id)
        .delete();
  }

///////////////////////////kalendar
  Stream<QuerySnapshot<Map<String, dynamic>>> listenReminders() {
    print("=---------------------------------------------");
    return FirebaseFirestore.instance
        .collection('Reminders')
        .where("students", arrayContains: ua.currentUser!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenExtracurriculars() {
    print("AAAAAAAAAAAAAAAAAA" + ua.currentUser!.uid);
    return FirebaseFirestore.instance
        .collection('Extracurriculars')
        .where("studentId", isEqualTo: ua.currentUser!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenStudentAssigments() {
    return FirebaseFirestore.instance
        .collection('ScheduleAssignments')
        .where("studentId", isEqualTo: ua.currentUser!.uid)
        .snapshots();
  }

///////////////////////////////////////////////////////////////////////////////////
  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentCourses() {
    return FirebaseFirestore.instance
        .collection('Courses')
        .where("students", arrayContains: ua.currentUser!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudents(String courseId) {
    return FirebaseFirestore.instance
        .collection('Users')
        .where("type", isEqualTo: "student")
        .where("courses", arrayContains: courseId)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentsFromCourse(
      String courseId) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .where("type", isEqualTo: "student")
        .where("courses", arrayContains: courseId)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTeacherRemider(String id) {
    print(id);
    return FirebaseFirestore.instance
        .collection('Reminders')
        .where("class", isEqualTo: id)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCourse({
    required String code,
  }) async {
    return await FirebaseFirestore.instance
        .collection('Courses')
        .where('code', isEqualTo: code)
        .get();
  }

  Stream<QuerySnapshot<Object?>> getTeacherPopUps(String id) {
    return popups.where("class", isEqualTo: id).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentPopUps() {
    return FirebaseFirestore.instance
        .collection('Popups')
        .where("students", arrayContains: ua.currentUser!.uid)
        .snapshots();
  }

  void addPopUpRate(String id, int rate) {
    popups.doc(id).update({
      "numRate": FieldValue.increment(1),
      "sumRate": FieldValue.increment(rate),
      "students": FieldValue.arrayRemove([ua.currentUser!.uid])
    });
  }

  void addCourseToUser(String classid) {
    users.doc(ua.currentUser!.uid).update({
      "courses": FieldValue.arrayUnion([classid])
    });
  }

  void addUserToCourse(String id) {
    courses.doc(id).update({
      "students": FieldValue.arrayUnion([ua.currentUser!.uid])
    });
  }

  Future<Map<String, dynamic>?> readUser(String uid) async {
    DocumentSnapshot documentSnapshot = await ua.users.doc(uid).get();
    return documentSnapshot.exists
        ? documentSnapshot.data()! as Map<String, dynamic>
        : null;
  }
}
