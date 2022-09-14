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

  Future<List<String>> addRemindersCopyForStudents(
      {required String classId,
      required DateTime date,
      required String title}) async {
    List<String> ids = [];
    for (var student in ((await courses.doc(classId).get()).data()!
            as Map<String, dynamic>)["students"] ??
        []) {
      final doc =
          await FirebaseFirestore.instance.collection('ScheduleReminders').add({
        "studentId": student,
        //"class": classId,
        "date": date,
        "title": title,
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
      "date": date,
      "title": title,
      "studentsCopy": ids
          .map((e) => FirebaseFirestore.instance.doc("ScheduleReminders/$e"))
          .toList()
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

  Future<List<String>> insertAssignmentCopyForStudents(
      MyAssignment mya, String courseId) async {
    List<String> ids = [];
    QuerySnapshot<Map<String, dynamic>> students = await getStudentsFromCourse(
        courseId); //?vec imas studenti koji su na odredjeni predmen ne mora se ponovo citaju
    for (var student in students.docs) {
      final doc = await FirebaseFirestore.instance
          .collection('ScheduleAssignments')
          .add({
        "studentId": student.id,
        "note": mya.note,
        "time": mya.duration,
        "title": mya.coursework!.title,
        "date": mya.coursework!.dueDate ??
            DateTime.now().add(const Duration(days: 7)),
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
          "dueDate": mya.coursework!.dueDate ??
              DateTime.now().add(const Duration(days: 7)),
          "title": mya.coursework!.title,
          "studentsCopy": ids
              .map((e) =>
                  FirebaseFirestore.instance.doc("ScheduleAssignments/$e"))
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
          "dueDate": mya.coursework!.dueDate ??
              DateTime.now().add(const Duration(days: 7))
        });
        for (DocumentReference<Map<String, dynamic>> ref
            in (ds.data() as Map<String, dynamic>)["studentsCopy"] ?? []) {
          ref.update({
            "note": mya.note,
            "time": mya.duration,
            "dueDate": mya.coursework!.dueDate ??
                DateTime.now().add(const Duration(days: 7))
          });
        }
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
