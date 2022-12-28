import 'dart:developer';

import 'package:calendair/models/assignment_model.dart';
import 'package:calendair/models/notification_settings_model.dart';
import 'package:calendair/models/popup_model.dart';
import 'package:calendair/models/remider_model.dart';
import 'package:calendair/models/user_model.dart';
import 'package:calendair/models/course_model.dart';
import 'package:calendair/schedule/schedule_element_extracurricular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/classroom/v1.dart' as google_api;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

class FirebaseController {
  FirebaseController() {
    _initializeFirebase();
  }
  UserModel? currentUser;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference<Map<String, dynamic>> schedule =
      FirebaseFirestore.instance.collection('Schedule');
  CollectionReference<Map<String, dynamic>> courses =
      FirebaseFirestore.instance.collection('Courses');
  CollectionReference<Map<String, dynamic>> extracurriculars =
      FirebaseFirestore.instance.collection('Extracurriculars');
  CollectionReference<Map<String, dynamic>> assignments =
      FirebaseFirestore.instance.collection('Assignments');
  CollectionReference<Map<String, dynamic>> popups =
      FirebaseFirestore.instance.collection('Popups');
  CollectionReference<Map<String, dynamic>> reminders =
      FirebaseFirestore.instance.collection('Reminders');
  final googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/classroom.courses',
      'https://www.googleapis.com/auth/classroom.rosters',
      'https://www.googleapis.com/auth/classroom.coursework.students'
    ],
  );
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

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
        await auth.signInWithCredential(credential);
        currentUser = await getUser(auth.currentUser!.uid);
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

  Future<UserModel?> getUser(String? uid) async {
    if (uid == null) {
      return null;
    }
    final ds = await users.doc(uid).get();
    if (ds.exists) {
      return UserModel.fromMap(ds.data()!, ds.id);
    }
    return null;
  }

  Future<bool> addUser({required UserModel user}) async {
    final u = await users.doc(user.uid).get();
    if (u.exists) {
      currentUser = UserModel.fromMap(u.data()!, u.id);
      return true;
    }
    if (user.type == "student") {
      users.doc(user.uid).set(user.toMapStudent(), SetOptions(merge: true));
    } else {
      users.doc(user.uid).set(user.toMapTeacher(), SetOptions(merge: true));
    }
    currentUser = user;
    return false;
  }

  Future<UserModel?> register(String uid) async {
    final u = await users.doc(uid).get();
    if (u.exists) {
      currentUser = UserModel.fromMap(u.data()!, u.id);
      return currentUser;
    }
    currentUser = null;
    return null;
  }

  //_____teacher___________
//!testirano
  Future<List<AssignmentModel>> getFirestoreAssignmet(String courseId) async {
    final docs = await assignments.where('courseId', isEqualTo: courseId).get();
    return docs.docs
        .map(
          (e) => AssignmentModel.fromMap(e.data(), e.id),
        )
        .toList();
  }

//!testirana
  Stream<QuerySnapshot<Map<String, dynamic>>> getTeacherCourses() {
    return courses.where("creatorId", isEqualTo: currentUser!.uid).snapshots();
  }

//!testirana
  Stream<QuerySnapshot<Map<String, dynamic>>> getStudents(String courseId) {
    return users
        .where("type", isEqualTo: "student")
        .where("courses", arrayContains: courseId)
        .snapshots();
  }

  Future<List<AssignmentModel>> getAssigments(
      String courseId, String courseDocId) async {
    List<AssignmentModel> list = [];
    if (googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = google_api.ClassroomApi(authenticateClient);
      final assignmets = await getFirestoreAssignmet(courseDocId);
      for (google_api.CourseWork cw
          in ((await cra.courses.courseWork.list(courseId)).courseWork ?? [])) {
        if (assignmets
                .firstWhereOrNull((element) => element.assignmentId == cw.id) ==
            null) {
          list.add(AssignmentModel(
              courseId: courseDocId,
              materials: getMaterials(cw.materials),
              assignmentId: cw.id!,
              title: cw.title!,
              duration: 0,
              docId: "",
              dueDate: cw.dueDate != null
                  ? DateTime(
                      cw.dueDate!.year!, cw.dueDate!.month!, cw.dueDate!.day!)
                  : DateTime.now().add(const Duration(days: 7))));
        }
      }
      return list + assignmets;
    }
    return [];
  }

  Future<List<DocumentReference<Map<String, dynamic>>>>
      insertAssignmentCopyForStudents(
          AssignmentModel assignment, CourseModel course) async {
    List<DocumentReference<Map<String, dynamic>>> ids = [];
    for (var student in course.students) {
      final doc = await FirebaseFirestore.instance.collection('Schedule').add({
        "studentId": student,
        "note": assignment.note,
        "type": "assignment",
        "index": 1000,
        "duration": assignment.duration,
        "times": [],
        "indexes": [],
        "dates": [],
        "remainingTimes": [],
        "title": assignment.title,
        "dueDate": assignment.dueDate,
        "materials": assignment.materials
      });
      ids.add(FirebaseFirestore.instance.doc("Schedule/${doc.id}"));
    }
    return ids;
  }

//!radi valjda
  List<String> getMaterials(List<google_api.Material>? materials) {
    List<String> mat = [];
    for (google_api.Material element in materials ?? []) {
      if (element.driveFile != null) {
        mat.add(element.driveFile!.driveFile?.alternateLink ?? "");
      } else if (element.link != null) {
        mat.add(element.link!.url ?? "");
      } else if (element.youtubeVideo != null) {
        mat.add(element.youtubeVideo!.alternateLink ?? "");
      }
    }
    return mat;
  }

  Future<void> updateAssignment(
      {required AssignmentModel assignment,
      required CourseModel course}) async {
    if (assignment.docId != "") {
      final value = await assignments.doc(assignment.docId).get();
      if (value.exists) {
        assignments.doc(assignment.docId).update({
          "note": assignment.note,
          "duration": assignment.duration,
          "dueDate": assignment.dueDate
        });
        inspect(assignment.studentsCopy);
        for (var element in assignment.studentsCopy) {
          element.update({
            "note": assignment.note,
            "duration": assignment.duration,
            "dueDate": assignment.dueDate
          });
        }
        return;
      }
    }
    final ids = await insertAssignmentCopyForStudents(assignment, course);
    assignment.studentsCopy = ids;
    assignments
        .add(assignment.toMap())
        .then((value) => assignment.docId = value.id);
  }

//!testirana
  Future<List<ReminderModel>> getTeacherRemider(String courseId) async {
    return (await FirebaseFirestore.instance
            .collection('Reminders')
            .where("courseId", isEqualTo: courseId)
            .get())
        .docs
        .map((e) => ReminderModel.fromMap(e.data(), e.id))
        .toList();
  }

//!testirano moze da se proveri ponovo kad se doda student
  Future<List<String>> addRemindersCopyForStudents(
      {required CourseModel course,
      required DateTime date,
      required String title}) async {
    List<String> ids = [];
    for (var student in course.students) {
      final doc = await FirebaseFirestore.instance.collection('Schedule').add({
        "studentId": student,
        "dueDate": DateUtils.dateOnly(date),
        "title": title,
        "type": "reminder",
        "index": -1
      });
      ids.add(doc.id);
    }
    return ids;
  }

//!testirano moze da se proveri ponovo kad se doda student
  Future<ReminderModel> addReminder(
      {required CourseModel course,
      required DateTime date,
      required String title}) async {
    final ids = await addRemindersCopyForStudents(
        course: course, date: date, title: title);
    final reminder = ReminderModel(
        courseId: course.docId,
        date: Timestamp.fromDate(DateUtils.dateOnly(date)),
        docId: "",
        studentsCopy: ids
            .map((e) => FirebaseFirestore.instance.doc("Schedule/$e"))
            .toList(),
        title: title);
    final doc = await reminders.add(reminder.toMap());
    reminder.docId = doc.id;
    return reminder;
  }

//!testirano moze da se proveri ponovo kad se doda student
  void updateReminder({required ReminderModel r}) {
    reminders.doc(r.docId).update({
      "title": r.title,
      "dueDate": r.date,
    });
    for (var s in r.studentsCopy) {
      s.update({
        "title": r.title,
        "dueDate": r.date,
      });
    }
  }

//!testirano
  Future<List<PopUpModel>> getTeacherPopUps(String classId) async {
    return (await popups.where("courseId", isEqualTo: classId).get())
        .docs
        .map(
          (e) => PopUpModel.fromMap(e.data(), e.id),
        )
        .toList();
  }

//!testirano
  Future<PopUpModel> getPopUp(String popupId) async {
    final popup = await popups.doc(popupId).get();
    return PopUpModel.fromMap(popup.data()!, popup.id);
  }

  Future<PopUpModel> addPopUp({required PopUpModel popUpModel}) async {
    final p = await popups.add(popUpModel.toMap());
    popUpModel.docId = p.id;
    return popUpModel;
  }

//!testirano
  Future<List<google_api.Course>> getCourseList() async {
    if (googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = google_api.ClassroomApi(authenticateClient);
      final lcr = await cra.courses.list(teacherId: "me");
      return lcr.courses != null
          ? lcr.courses!
              .where((google_api.Course course) =>
                  !currentUser!.courses.contains(course.id))
              .toList()
          : [];
    }
    return [];
  }

//!testirano
  void addCourse({required google_api.Course course}) {
    FirebaseFirestore.instance.collection('Courses').add({
      "classroomId": course.id,
      "classCode": course.enrollmentCode,
      "className": course.name,
      "creatorId": currentUser!.uid,
      "students": []
    });
    currentUser!.courses.add(course.id!);
    addCourseToUser(course.id!);
  }

//!testirano
  void addCourseToUser(String classid) {
    users.doc(currentUser!.uid).update({
      "courses": FieldValue.arrayUnion([classid])
    });
  }

//!testirano
  void addUserToCourse(String courseId) {
    courses.doc(courseId).update({
      "students": FieldValue.arrayUnion([currentUser!.uid])
    });
  }

//!testirano
  Future<String> createCourse(String name, String period) async {
    if (googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = google_api.ClassroomApi(authenticateClient);
      final c = await cra.courses
          .create(google_api.Course(name: name, ownerId: 'me'));
      addCourse(course: c);
      return c.enrollmentCode!;
    }
    return "";
  }
  //_____teacher___________
//______student____________

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentPopUps() {
    return popups
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

  void addBreakDay(int dayIndex) {
    currentUser?.breakday = dayIndex;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .update({"breakday": dayIndex});
  }

  Future<List<ScheduleElementExtracurricular>> getExtracurriculars() async {
    return (await extracurriculars
            .where("studentId", isEqualTo: currentUser!.uid)
            .where("type", isEqualTo: "extracurricular")
            .get())
        .docs
        .map((e) => ScheduleElementExtracurricular.fromMap(
            map: e.data(), docId: e.id, changeType: DocumentChangeType.added))
        .toList();
  }

  Future<ScheduleElementExtracurricular> addExtracurricular(
      {required ScheduleElementExtracurricular extracurricularModel}) async {
    final doc = await extracurriculars.add(extracurricularModel.toMap());
    extracurricularModel.docId = doc.id;
    return extracurricularModel;
  }

  Future<void> setTimes(Map<String, dynamic> t) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.uid)
        .update({"times": t});
  }

  Future<void> addReminderStudent(
      {required DateTime date, required String title}) async {
    await FirebaseFirestore.instance.collection('Schedule').add({
      "studentId": currentUser!.uid,
      "dueDate": DateUtils.dateOnly(date),
      "title": title,
      "type": "reminder",
      "index": -1
    });
  }

  void deleteExtracurriculars(ScheduleElementExtracurricular ex) {
    extracurriculars.doc(ex.docId).delete();
  }

  void updateExtracurriculars(ScheduleElementExtracurricular ex) {
    extracurriculars.doc(ex.docId).update(ex.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentCourses() {
    return courses
        .where("students", arrayContains: currentUser!.uid)
        .snapshots();
  }

//!testirano
  Future<CourseModel?> getCourse({
    required String code,
  }) async {
    final doc = (await courses.where('classCode', isEqualTo: code).get()).docs;
    if (doc.isNotEmpty) {
      return CourseModel.fromMap(doc.first.data(), doc.first.id);
    }
    return null;
  }

  Future<String> enrolToCourse(String code) async {
    if (googleSignIn.currentUser != null) {
      String name = "";
      try {
        final c = await getCourse(code: code);
        if (c != null) {
          name = c.className;
          final baseClient = Client();
          final authenticateClient = AuthenticateClient(
              await googleSignIn.currentUser!.authHeaders, baseClient);
          final cra = google_api.ClassroomApi(authenticateClient);
          addCourseToUser(c.docId);
          addUserToCourse(c.docId);
          await cra.courses.students.create(
              google_api.Student(userId: 'me'), c.classroomId,
              enrollmentCode: code);
          return name;
        } else {
          return "";
        }
      } on google_api.DetailedApiRequestError catch (e) {
        if (e.status == 409) {
          return name;
        }
        Get.snackbar("Error", e.message ?? "");
      }
    }
    return "Error";
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

  void updateNotificationSettings(NotificationSettingsModel nsm) {
    currentUser!.notifications[nsm.id] = nsm.checked;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .update({'notifications': currentUser!.notifications});
  }
//______student____________
}

class AuthenticateClient extends BaseClient {
  final Map<String, String> headers;
  final Client client;
  AuthenticateClient(this.headers, this.client);
  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return client.send(request..headers.addAll(headers));
  }
}
