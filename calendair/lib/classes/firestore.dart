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
import 'package:calendair/models/notificationSettingsModel.dart';
import 'package:calendair/models/reminderModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'Authentication.dart';
import 'package:intl/intl.dart';

class Firestore {
  static final Firestore _singleton = Firestore._internal();
  final ua = UserAuthentication();
  final gc = Get.find<GoogleClassroom>();
  UserModel? firebaseUser;
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
        firebaseUser = UserModel.fromMap({
          "courses": [],
          "type": user.type,
          'name': user.name,
          "picture": user.picture,
          "times": <String, dynamic>{},
          'extracurricularsTimes': [0, 0, 0, 0, 0, 0, 0],
          if (user.type == "student") ...{
            "breakday": -1,
            "remindersNotification": [
              NotificationSettingsModel(
                  'Remind to complete unfinished assignments the day before the due date',
                  false,
                  "finishAssignments"),
              NotificationSettingsModel(
                  'Send inspirational quote to encourage studying', false, null)
            ].map((e) => e.toMap()).toList(),
            "updatesNotification": [
              NotificationSettingsModel(
                  'Update on teacher announcements', false, null),
              NotificationSettingsModel(
                  'Update on confidence meter popups', false, "popups"),
              NotificationSettingsModel(
                  'Update on TOS and app development updates', false, null)
            ].map((e) => e.toMap()).toList(),
            "assignmentsNotification": [
              NotificationSettingsModel('Send when a new assignment is posted',
                  false, "newAssignments"),
              NotificationSettingsModel(
                  'Send when a new exam is posted', false, null),
              NotificationSettingsModel(
                  'Send notification when assignment is done (via timer) ',
                  false,
                  "assignmentFinished"),
              NotificationSettingsModel(
                  'Keep notification pinned with an ongoing assignment timer',
                  false,
                  null),
              NotificationSettingsModel(
                  'Notify when teacher edits an assignment',
                  false,
                  "assignmentsEdit"),
            ].map((e) => e.toMap()).toList(),
          }
        }, user.id);
        if (user.type == "student") {
          users
              .doc(user.id)
              .set(firebaseUser!.toMapStudent(), SetOptions(merge: true));
        } else {
          users
              .doc(user.id)
              .set(firebaseUser!.toMapTeacher(), SetOptions(merge: true));
        }
      }
    });
  }

  void subscribeToTopics() {
    if (firebaseUser != null) {
      for (var obj in firebaseUser!.remindersNotification) {
        if (obj.channel != null && obj.checked == true) {
          for (var id in firebaseUser!.courses) {
            FCMNotification.subscribeToTopic("$id" "${obj.channel!}");
            print("$id" "${obj.channel!}");
          }
        }
      }
      for (var obj in firebaseUser!.assignmentsNotification) {
        if (obj.channel != null && obj.checked == true) {
          if (obj.channel == "assignmentFinished") {
          } else {
            for (var id in firebaseUser!.courses) {
              FCMNotification.subscribeToTopic("$id" "${obj.channel!}");
              print("$id" "${obj.channel!}");
            }
          }
        }
      }
      for (var obj in firebaseUser!.updatesNotification) {
        if (obj.channel != null && obj.checked == true) {
          for (var id in firebaseUser!.courses) {
            FCMNotification.subscribeToTopic("$id" "${obj.channel!}");
            print("$id" "${obj.channel!}");
          }
        }
      }
    }
  }

  void updateUser({required String name, String? img}) {
    firebaseUser?.name = name;
    if (img != null) {
      firebaseUser?.picture = img;
    }
    if (firebaseUser != null) {
      users.doc(ua.currentUser!.uid).update(
          {"name": firebaseUser!.name, "picture": firebaseUser!.picture});
    }
  }

  Future<String> getUserIfExist(String UID) async {
    final ds = await users.doc(UID).get();
    if (ds.exists) {
      firebaseUser = UserModel.fromMap(ds.data()!, ds.id);
      inspect(firebaseUser);
      if (ds["type"] == "student") {
        FCMNotification.unsubscribeFromAllTopic();
        subscribeToTopics();
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
    print("${courseId}popups");
    FCMNotification.sendTopicMessage(
        channel: "${classId}popups",
        title: "Popup added",
        body: "${ua.currentUser!.displayName} added $title");
  }

  //lSutwl51je0Vz1lKQwdEpopups
//I/flutter (32204): MIMasVGWgVkOpCbRrXmCpopups
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

  void updateExtracurriculars(
      ExtracurricularsModel ex, int prevIndex, int prevTime) {
    inspect(ex.toMap());
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(ex.id)
        .update(ex.toMap());

    //TODO: UPDEJTUJ VREME TREBA DA SE PROSLEDI I STARI EXTRAC...

    FirebaseFirestore.instance
        .collection('Users')
        .doc(ua.currentUser!.uid)
        .get()
        .then((value) {
      inspect(value.data());
      final List<int> times =
          ((value.data()?['extracurricularsTimes'] ?? []) as List<dynamic>)
              .map((e) => e as int)
              .toList();
      times[ex.dayIndex] += ex.time;
      times[prevIndex] -= prevTime;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(ua.currentUser!.uid)
          .update({"extracurricularsTimes": times});
    });
  }

  void addBreakDay(int dayIndex) {
    firebaseUser?.breakday = dayIndex;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(ua.currentUser!.uid)
        .update({"breakday": dayIndex});
  }

  void updateNotificationSettings(
      String settings, NotificationSettingsModel nsm) {
    if (nsm.channel != null && nsm.checked == true) {
      for (var id in firebaseUser!.courses) {
        FCMNotification.subscribeToTopic("$id" "${nsm.channel!}");
        print("$id" "${nsm.channel!}");
      }
    } else if (nsm.channel != null && nsm.checked == false) {
      for (var id in firebaseUser!.courses) {
        FCMNotification.unsubscribeFromTopic("$id" "${nsm.channel!}");
        print("unsubscribe $id" "${nsm.channel!}");
      }
    }

    final doc =
        FirebaseFirestore.instance.collection('Users').doc(ua.currentUser!.uid);
    if (settings == "assignmentsNotification") {
      doc.update({
        settings:
            firebaseUser?.assignmentsNotification.map((e) => e.toMap()).toList()
      });
    } else if (settings == "updatesNotification") {
      doc.update({
        settings:
            firebaseUser?.updatesNotification.map((e) => e.toMap()).toList()
      });
    } else if (settings == "remindersNotification") {
      doc.update({
        settings:
            firebaseUser?.remindersNotification.map((e) => e.toMap()).toList()
      });
    }
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

    FirebaseFirestore.instance
        .collection('Users')
        .doc(ua.currentUser!.uid)
        .get()
        .then((value) {
      inspect(value.data());
      final List<int> times =
          ((value.data()?['extracurricularsTimes'] ?? []) as List<dynamic>)
              .map((e) => e as int)
              .toList();
      times[dayIndex] += time;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(ua.currentUser!.uid)
          .update({"extracurricularsTimes": times});
    });
  }

  Future<List<String>> insertAssignmentCopyForStudents(
      MyAssignment mya, String courseId, List<String> materials) async {
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
            : DateUtils.dateOnly(
                DateTime.now().add(
                  const Duration(days: 7),
                ),
              ),
        "materials": materials
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
        FCMNotification.sendTopicMessage(
            channel: "${courseId}newAssignments",
            title: "Assignment added",
            body:
                "${ua.currentUser!.displayName} added ${mya.coursework!.title}");
        final List<String> materials = [];
        for (classroom.Material element in mya.coursework!.materials ?? []) {
          inspect(element);
          if (element.driveFile != null) {
            materials.add(element.driveFile!.driveFile?.alternateLink ?? "");
          } else if (element.link != null) {
            materials.add(element.link!.url ?? "");
          } else if (element.youtubeVideo != null) {
            materials.add(element.youtubeVideo!.alternateLink ?? "");
          }
        }
        //insert
        final ids =
            await insertAssignmentCopyForStudents(mya, courseId, materials);
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
        FCMNotification.sendTopicMessage(
            channel: "${courseId}assignmentsEdit",
            title: "Assignment changed",
            body:
                "${ua.currentUser!.displayName} changed the assignment ${mya.coursework!.title}");
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

  Future<MyAssignment> readMyAssignment(classroom.CourseWork cw) async {
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
    FirebaseFirestore.instance
        .collection('Users')
        .doc(ua.currentUser!.uid)
        .get()
        .then((value) {
      inspect(value.data());
      final List<int> times =
          ((value.data()?['extracurricularsTimes'] ?? []) as List<dynamic>)
              .map((e) => e as int)
              .toList();
      times[ex.dayIndex] -= ex.time;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(ua.currentUser!.uid)
          .update({"extracurricularsTimes": times});
    });
  }

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
