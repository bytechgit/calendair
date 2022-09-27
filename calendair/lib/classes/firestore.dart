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

import 'package:calendair/classes/googleClassroom.dart';
import 'package:calendair/classes/fcmNotification.dart';
import 'package:calendair/models/AssignmentModel.dart';
import 'package:calendair/models/ExtracurricularsModel.dart';
import 'package:calendair/models/UserModel.dart';
import 'package:calendair/models/reminderModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'Authentication.dart';
import 'package:intl/intl.dart';

class Firestore {
  static final Firestore _singleton = Firestore._internal();
  final ua = UserAuthentication();
  final gc = Get.find<GoogleClassroom>();
  String? userName;
  String? userImgUrl;
  factory Firestore() {
    return _singleton;
  }

  final firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference courses =
      FirebaseFirestore.instance.collection('Courses');
  CollectionReference popups = FirebaseFirestore.instance.collection('Popups');
  CollectionReference reminder =
      FirebaseFirestore.instance.collection('Reminders');

  Firestore._internal() {
    _initializeFirebase();
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  void addUserIfNotExist({required UserModel user}) {
    users.doc(user.id).get().then((DocumentSnapshot ds) {
      if (!ds.exists) {
        users.doc(user.id).set({
          "courses": [],
          "type": user.type,
          "name": user.name,
          "picture": user.picture,
          "times": {}
        }, SetOptions(merge: true));
      }
    });
  }

  void updateUser({required String name, String? img}) {
    userName = name;
    userImgUrl = img ?? userImgUrl;
    users
        .doc(ua.currentUser!.uid)
        .update({"name": userName, "picture": userImgUrl});
  }

  Future<String> getUserIfExist(String UID) async {
    final ds = await users.doc(UID).get();
    if (ds.exists) {
      inspect(ds.data());
      userName = ds.data()!["name"];
      userImgUrl = ds.data()!["picture"];
      if (ds["type"] == "student") {
        FCMNotification.unsubscribeFromAllTopic();
        Firestore().getStudentCourses().listen((s) {
          for (var doc in s.docs) {
            String courseId = doc.data()["id"];
            FCMNotification.subscribeToTopic("${courseId}_assignments");
            FCMNotification.subscribeToTopic("${courseId}_popups");
            print("SCUBSCRIBED ON${courseId}_assignments");
          }
        });
      }

      return ds["type"];
    }
    return "";
  }

  Future<Map<String, dynamic>> getTimes() async {
    final ds = await FirebaseFirestore.instance
        .collection("Users")
        .doc(ua.currentUser!.uid)
        .get();
    return ds.data()!["times"];
  }

  Future<void> setTimes(Map<String, dynamic> t) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(ua.currentUser!.uid)
        .update({"times": t});
  }

  Future<void> addPopUp(
      {required String classId,
      required String courseId,
      required DateTime date,
      required String title,
      required String cm}) async {
    popups.add({
      "class": classId,
      "dueDate": DateUtils.dateOnly(date),
      "title": title,
      "numRate": 0,
      "sumRate": 0,
      "question": cm,
      "order": DateUtils.dateOnly(DateTime.now()),
      "students": ((await courses.doc(classId).get()).data()!
              as Map<String, dynamic>)["students"] ??
          []
    });
    FCMNotification.sendTopicMessage(
        channel: "${courseId}_popups",
        title: "Popup added",
        body: "${ua.currentUser!.displayName} added $title");

    print("${courseId}_popups");
  }

  Future<void> addReminderStudent(
      {required DateTime date, required String title}) async {
    await FirebaseFirestore.instance.collection('Schedule').add({
      "studentId": ua.currentUser!.uid,
      //"class": classId,
      "date": DateUtils.dateOnly(date),
      "title": title,
      "type": "reminder",
      "index": -1
    });
  }

  Future<List<String>> addRemindersCopyForStudents(
      {required String classId,
      required DateTime date,
      required String title}) async {
    List<String> ids = [];
    for (var student in ((await courses.doc(classId).get()).data()!
            as Map<String, dynamic>)["students"] ??
        []) {
      final doc = await FirebaseFirestore.instance.collection('Schedule').add({
        "studentId": student,
        //"class": classId,
        "date": DateUtils.dateOnly(date),
        "title": title,
        "type": "reminder",
        "index": -1
      });
      ids.add(doc.id);
    }
    return ids;
  }

  Future<void> addReminder(
      {required String classId,
      required DateTime date,
      required String title}) async {
    final ids = await addRemindersCopyForStudents(
        classId: classId, date: date, title: title);
    reminder.add({
      "class": classId,
      "date": DateUtils.dateOnly(date),
      "title": title,
      "studentsCopy":
          ids.map((e) => FirebaseFirestore.instance.doc("Schedule/$e")).toList()
    });
  }

  void updateReminder({required ReminderModel r}) {
    reminder.doc(r.id).update({
      "title": r.title,
      "date": r.date,
    });
    for (var s in r.studentsCopy) {
      s.update({
        "title": r.title,
        "date": r.date,
      });
    }
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
        .collection('Schedule')
        .where("studentId", isEqualTo: ua.currentUser!.uid)
        .where("type", isEqualTo: "extracurricular")
        .snapshots();
  }

  void updateExtracurriculars(ExtracurricularsModel ex) {
    inspect(ex.toMap());
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(ex.id)
        .update(ex.toMap());
  }

  void addBreakDay(int dayIndex) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(ua.currentUser!.uid)
        .update({"breakday": dayIndex});
  }

  Future<int> getBreakday() async {
    return (await FirebaseFirestore.instance
            .collection('Users')
            .doc(ua.currentUser!.uid)
            .get())
        .data()!["breakday"];
  }

  void addExtracurriculars(int time, String title, int dayIndex) {
    FirebaseFirestore.instance.collection('Schedule').add({
      "title": title,
      "time": time,
      "dayIndex": dayIndex,
      "studentId": ua.currentUser!.uid,
      "type": "extracurricular",
      "index": 1000,
      "date": null
    });
  }

//!ako je profesor stavio da traje 50 min to je podeljeno na dva dela 30,20 i sad ako je student vec zavrsio ovaj deo od 30 i ostalo mu
//! od 20 a profesor promeni vreme sta se onda desava

  Future<List<String>> insertAssignmentCopyForStudents(
      MyAssignment mya, String courseId) async {
    List<String> ids = [];
    QuerySnapshot<Map<String, dynamic>> students = await getStudentsFromCourse(
        courseId); //?vec imas studenti koji su na odredjeni predmen ne mora se ponovo citaju
    for (var student in students.docs) {
      final doc = await FirebaseFirestore.instance.collection('Schedule').add({
        "studentId": student.id,
        "note": mya.note,
        "type": "assignment",
        "date": DateTime(2100),
        "index": 100,
        "time": mya.duration,
        "times": [],
        "indexes": [],
        "finishedList": [],
        "dates": [],
        "title": mya.coursework!.title,
        "dueDate": mya.coursework!.dueDate != null
            ? DateTime(mya.coursework!.dueDate!.year!,
                mya.coursework!.dueDate!.month!, mya.coursework!.dueDate!.day!)
            : DateUtils.dateOnly(DateTime.now().add(const Duration(days: 7))),
      });
      ids.add(doc.id);
    }
    return ids;
  }

  Future<void> insertOrUpdateAssignment(
      MyAssignment mya, String courseId) async {
    FirebaseFirestore.instance
        .collection('Assignments')
        .doc(mya.coursework!.courseId! + mya.coursework!.id!)
        .get()
        .then((DocumentSnapshot ds) async {
      if (!ds.exists) {
        //insert
        final ids = await insertAssignmentCopyForStudents(mya, courseId);
        FirebaseFirestore.instance
            .collection('Assignments')
            .doc(mya.coursework!.courseId! + mya.coursework!.id!)
            .set({
          "note": mya.note,
          "duration": mya.duration,
          "dueDate": mya.coursework!.dueDate != null
              ? DateTime(
                  mya.coursework!.dueDate!.year!,
                  mya.coursework!.dueDate!.month!,
                  mya.coursework!.dueDate!.day!)
              : DateUtils.dateOnly(DateTime.now().add(const Duration(days: 7))),
          "title": mya.coursework!.title,
          "studentsCopy": ids
              .map((e) => FirebaseFirestore.instance.doc("Schedule/$e"))
              .toList()
        }, SetOptions(merge: true));
      } else //update
      {
        FirebaseFirestore.instance
            .collection('Assignments')
            .doc(mya.coursework!.courseId! + mya.coursework!.id!)
            .update({
          "note": mya.note,
          "duration": mya.duration,
          "dueDate": mya.coursework!.dueDate != null
              ? DateTime(
                  mya.coursework!.dueDate!.year!,
                  mya.coursework!.dueDate!.month!,
                  mya.coursework!.dueDate!.day!)
              : DateUtils.dateOnly(DateTime.now().add(const Duration(days: 7))),
        });
        for (DocumentReference<Map<String, dynamic>> ref
            in (ds.data() as Map<String, dynamic>)["studentsCopy"] ?? []) {
          ref.update({
            "note": mya.note,
            "time": mya.duration,
            "dueDate": mya.coursework!.dueDate != null
                ? DateTime(
                    mya.coursework!.dueDate!.year!,
                    mya.coursework!.dueDate!.month!,
                    mya.coursework!.dueDate!.day!)
                : DateUtils.dateOnly(
                    DateTime.now().add(const Duration(days: 7))),
          });
        }
      }
    });
  }

  // Future<List<DocumentReference<Map<String, dynamic>>>>
  //     insertAssignmentCopyForStudents(MyAssignment mya, String courseId) async {
  //   List<DocumentReference<Map<String, dynamic>>> ids = [];
  //   QuerySnapshot<Map<String, dynamic>> students = await getStudentsFromCourse(
  //       courseId); //?vec imas studenti koji su na odredjeni predmen ne mora se ponovo citaju
  //   for (var student in students.docs) {
  //     for (var t in getTimes(mya.duration)) {
  //       final doc =
  //           await FirebaseFirestore.instance.collection('Schedule').add({
  //         "studentId": student.id,
  //         "note": mya.note,
  //         "time": t,
  //         "finished": false,
  //         "title": mya.coursework!.title,
  //         "index": 500,
  //         "dueDate": mya.coursework!.dueDate != null
  //             ? DateTime(
  //                 mya.coursework!.dueDate!.year!,
  //                 mya.coursework!.dueDate!.month!,
  //                 mya.coursework!.dueDate!.day!)
  //             : DateUtils.dateOnly(
  //                 DateTime.now().add(const Duration(days: 14))),
  //         "type": "assignment",
  //         "date": DateTime(2100),
  //         "parentId": mya.coursework!.courseId! + mya.coursework!.id!
  //       });
  //       ids.add(FirebaseFirestore.instance.doc("Schedule/${doc.id}"));
  //     }
  //   }
  //   return ids;
  // }

  // Future<void> insertOrUpdateAssignment(
  //     MyAssignment mya, String courseId) async {
  //   FirebaseFirestore.instance
  //       .collection('Assignments')
  //       .doc(mya.coursework!.courseId! + mya.coursework!.id!)
  //       .get()
  //       .then((DocumentSnapshot ds) async {
  //     if (!ds.exists) {
  //       //insert
  //       final ids = await insertAssignmentCopyForStudents(mya, courseId);
  //       FirebaseFirestore.instance
  //           .collection('Assignments')
  //           .doc(mya.coursework!.courseId! + mya.coursework!.id!)
  //           .set({
  //         "note": mya.note,
  //         "duration": mya.duration,
  //         "dueDate": mya.coursework!.dueDate != null
  //             ? DateTime(
  //                 mya.coursework!.dueDate!.year!,
  //                 mya.coursework!.dueDate!.month!,
  //                 mya.coursework!.dueDate!.day!)
  //             : DateUtils.dateOnly(
  //                 DateTime.now().add(const Duration(days: 14))),
  //         "title": mya.coursework!.title,
  //         "studentsCopy": ids,
  //         "count": getTimes(mya.duration).length
  //       }, SetOptions(merge: true));
  //     } else //update
  //     {
  //       FirebaseFirestore.instance
  //           .collection('Assignments')
  //           .doc(mya.coursework!.courseId! + mya.coursework!.id!)
  //           .update({
  //         "note": mya.note,
  //         "duration": mya.duration,
  //         "dueDate": mya.coursework!.dueDate != null
  //             ? DateTime(
  //                 mya.coursework!.dueDate!.year!,
  //                 mya.coursework!.dueDate!.month!,
  //                 mya.coursework!.dueDate!.day!)
  //             : DateUtils.dateOnly(
  //                 DateTime.now().add(const Duration(days: 14))),
  //       });
  //       for (DocumentReference<Map<String, dynamic>> ref
  //           in (ds.data() as Map<String, dynamic>)["studentsCopy"] ?? []) {
  //         ref.update({
  //           "note": mya.note,
  //           "time": mya.duration, //!da se napravi da ne moze da se menja vreme
  //           "dueDate": mya.coursework!.dueDate != null
  //               ? DateTime(
  //                   mya.coursework!.dueDate!.year!,
  //                   mya.coursework!.dueDate!.month!,
  //                   mya.coursework!.dueDate!.day!)
  //               : DateUtils.dateOnly(
  //                   DateTime.now().add(const Duration(days: 14))),
  //         });
  //       }
  //     }
  //   });
  // }

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
    FirebaseFirestore.instance.collection('Schedule').doc(ex.id).delete();
  }

///////////////////////////kalendar

///////////////////////////////////////////////////////////////////////////////////
  ///

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

//! studenti mogu direktno iz kurs da se uzmu
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
        .where("dueDate",
            isGreaterThanOrEqualTo: DateUtils.dateOnly(DateTime.now()))
        .orderBy("dueDate")
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

  // void addTimes(List<int> times) {
  //   users.doc(ua.currentUser!.uid).update({"times": times});
  // }
  // List<int> getTimes(String id) {
  //   return popups.where("class", isEqualTo: id).snapshots();
  // }
}
