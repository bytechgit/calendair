import 'dart:async';
import 'package:calendair/classes/local_database.dart';
import 'package:calendair/models/UserModel.dart';
import 'package:calendair/models/assignment_model.dart';
import 'package:calendair/models/extracurriculars_model.dart';
import 'package:calendair/models/notificationSettingsModel.dart';
import 'package:calendair/models/reminderModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'fcm_notification.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;

class UserAuthentication {
  static final UserAuthentication _singleton = UserAuthentication._internal();
  factory UserAuthentication() {
    return _singleton;
  }
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference<Map<String, dynamic>> courses =
      FirebaseFirestore.instance.collection('Courses');
  CollectionReference<Map<String, dynamic>> popups =
      FirebaseFirestore.instance.collection('Popups');
  CollectionReference<Map<String, dynamic>> reminder =
      FirebaseFirestore.instance.collection('Reminders');
  UserModel? currentUser;
  LocalDatabase l = LocalDatabase();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  UserAuthentication._internal() {
    _initializeFirebase();
  }
  final googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/classroom.courses',
      'https://www.googleapis.com/auth/classroom.rosters',
      'https://www.googleapis.com/auth/classroom.coursework.students'
    ],
  );

  Future<void> signout() async {
    await googleSignIn.signOut();
    currentUser = null;
  }

  Future<UserModel?> signInwithGoogle() async {
    signout();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final googleAuth = await googleSignInAccount.authentication;
        googleAuth.accessToken;
        await auth.signInWithCredential(credential);
        currentUser = await getUserIfExist(auth.currentUser!.uid);
        return currentUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print(e);
      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  //////
  ///
  //
  void addUserIfNotExist({required UserModel user}) {
    users.doc(user.uid).get().then((DocumentSnapshot ds) {
      if (!ds.exists) {
        currentUser = UserModel.fromMap({
          "courses": user.courses,
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
        }, user.uid);
        if (user.type == "student") {
          users
              .doc(user.uid)
              .set(currentUser!.toMapStudent(), SetOptions(merge: true));
        } else {
          users
              .doc(user.uid)
              .set(currentUser!.toMapTeacher(), SetOptions(merge: true));
        }
      }
    });
  }

  void updateUser({required String name, String? img}) {
    currentUser?.name = name;
    if (img != null) {
      currentUser?.picture = img;
    }
    if (currentUser != null) {
      users
          .doc(currentUser!.uid)
          .update({"name": currentUser!.name, "picture": currentUser!.picture});
    }
  }

  Future<UserModel?> getUserIfExist(String? uid) async {
    if (uid == null) {
      return null;
    }
    final ds = await users.doc(uid).get();
    if (ds.exists) {
      return UserModel.fromMap(ds.data()!, ds.id);
    }
    return null;
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
      "students": ((await courses.doc(classId).get()).data()!)["students"] ?? []
    });
    FCMNotification.sendTopicMessage(
        channel: "${classId}popups",
        title: "Popup added",
        body: "${currentUser!.name} added $title");
  }

  Future<void> addReminderStudent(
      {required DateTime date, required String title}) async {
    await FirebaseFirestore.instance.collection('Schedule').add({
      "studentId": currentUser!.uid,
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
    for (var student
        in ((await courses.doc(classId).get()).data()!)["students"] ?? []) {
      final doc = await FirebaseFirestore.instance.collection('Schedule').add({
        "studentId": student,
        "date": DateUtils.dateOnly(date),
        "title": title,
        "type": "reminder",
        "index": -1
      });
      ids.add(doc.id);
    }
    return ids;
  }

  Future<void> setTimes(Map<String, dynamic> t) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.uid)
        .update({"times": t});
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
      "owner": currentUser!.uid,
      "students": []
    });
    addCourseToUser(classId);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTeacherCourses() {
    return FirebaseFirestore.instance
        .collection('Courses')
        .where("owner", isEqualTo: currentUser!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getExtracurriculars() {
    return FirebaseFirestore.instance
        .collection('Schedule')
        .where("studentId", isEqualTo: currentUser!.uid)
        .where("type", isEqualTo: "extracurricular")
        .snapshots();
  }

  void updateExtracurriculars(
      ExtracurricularsModel ex, int prevIndex, int prevTime) {
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(ex.id)
        .update(ex.toMap());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .get()
        .then((value) {
      //TODO: NE TREBA SVAKI PUT DA SE CITA VREME
      final List<int> times =
          ((value.data()?['extracurricularsTimes'] ?? []) as List<dynamic>)
              .map((e) => e as int)
              .toList();
      times[ex.dayIndex] += ex.time;
      times[prevIndex] -= prevTime;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .update({"extracurricularsTimes": times});
    });
  }

  void addBreakDay(int dayIndex) {
    currentUser?.breakday = dayIndex;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .update({"breakday": dayIndex});
  }

  void updateNotificationSettings(
      String settings, NotificationSettingsModel nsm) {
    if (nsm.channel != null && nsm.checked == true) {
      for (var id in currentUser!.courses) {
        FCMNotification.subscribeToTopic("$id" "${nsm.channel!}");
      }
    } else if (nsm.channel != null && nsm.checked == false) {
      for (var id in currentUser!.courses) {
        FCMNotification.unsubscribeFromTopic("$id" "${nsm.channel!}");
      }
    }
    final doc =
        FirebaseFirestore.instance.collection('Users').doc(currentUser!.uid);
    if (settings == "assignmentsNotification") {
      doc.update({
        settings:
            currentUser?.assignmentsNotification.map((e) => e.toMap()).toList()
      });
    } else if (settings == "updatesNotification") {
      doc.update({
        settings:
            currentUser?.updatesNotification.map((e) => e.toMap()).toList()
      });
    } else if (settings == "remindersNotification") {
      doc.update({
        settings:
            currentUser?.remindersNotification.map((e) => e.toMap()).toList()
      });
    }
  }

  void addExtracurriculars(int time, String title, int dayIndex) {
    FirebaseFirestore.instance.collection('Schedule').add({
      "title": title,
      "time": time,
      "dayIndex": dayIndex,
      "studentId": currentUser!.uid,
      "type": "extracurricular",
      "index": 1000,
      "date": null
    });

    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .get()
        .then((value) {
      final List<int> times =
          ((value.data()?['extracurricularsTimes'] ?? []) as List<dynamic>)
              .map((e) => e as int)
              .toList();
      times[dayIndex] += time;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
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
                "${auth.currentUser!.displayName} added ${mya.coursework!.title}");
        final List<String> materials = [];
        for (classroom.Material element in mya.coursework!.materials ?? []) {
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
                "${auth.currentUser!.displayName} changed the assignment ${mya.coursework!.title}");
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

  Future<MyAssignment> readMyAssignmentById(String id) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('Assignments')
        .doc(id)
        .get();
    if (ds.exists) {
      return MyAssignment.fromMap(ds.data() as Map<String, dynamic>, null);
    } else {
      return MyAssignment(null, 0, null);
    }
  }

  Future<MyAssignment> readMyAssignment(classroom.CourseWork cw) async {
    return readMyAssignmentById(cw.courseId! + cw.id!);
  }

  void deleteExtracurriculars(ExtracurricularsModel ex) {
    FirebaseFirestore.instance.collection('Schedule').doc(ex.id).delete();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .get()
        .then((value) {
      final List<int> times =
          ((value.data()?['extracurricularsTimes'] ?? []) as List<dynamic>)
              .map((e) => e as int)
              .toList();
      times[ex.dayIndex] -= ex.time;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .update({"extracurricularsTimes": times});
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentCourses() {
    return FirebaseFirestore.instance
        .collection('Courses')
        .where("students", arrayContains: currentUser!.uid)
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
        .where("students", arrayContains: currentUser!.uid)
        .where("dueDate",
            isGreaterThanOrEqualTo: DateUtils.dateOnly(DateTime.now()))
        .orderBy("dueDate")
        .snapshots();
  }

  void addPopUpRate(String id, int rate) {
    popups.doc(id).update({
      "numRate": FieldValue.increment(1),
      "sumRate": FieldValue.increment(rate),
      "students": FieldValue.arrayRemove([currentUser!.uid])
    });
  }

  void addCourseToUser(String classid) {
    users.doc(currentUser!.uid).update({
      "courses": FieldValue.arrayUnion([classid])
    });
  }

  void addUserToCourse(String id) {
    courses.doc(id).update({
      "students": FieldValue.arrayUnion([currentUser!.uid])
    });
  }

  Future<Map<String, dynamic>?> readUser(String uid) async {
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    return documentSnapshot.exists
        ? documentSnapshot.data()! as Map<String, dynamic>
        : null;
  }
}
