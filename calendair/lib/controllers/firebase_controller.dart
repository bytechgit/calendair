import 'dart:developer';

import 'package:calendair/models/assignment_model.dart';
import 'package:calendair/models/extracurricular_model.dart';
import 'package:calendair/models/notification_settings_model.dart';
import 'package:calendair/models/popup_model.dart';
import 'package:calendair/models/remider_model.dart';
import 'package:calendair/models/user_model.dart';
import 'package:calendair/models/course_model.dart';
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
  CollectionReference<Map<String, dynamic>> assignments =
      FirebaseFirestore.instance.collection('Assignments');
  CollectionReference<Map<String, dynamic>> popups =
      FirebaseFirestore.instance.collection('Popups');
  CollectionReference<Map<String, dynamic>> reminder =
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
    print(uid);
    final ds = await users.doc(uid).get();
    inspect(ds);
    if (ds.exists) {
      print("eee");
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

  Future<List<AssignmentModel>> getFirestoreAssignmet(String courseId) async {
    final docs = await assignments.where('courseId', isEqualTo: courseId).get();
    return docs.docs
        .map((e) => AssignmentModel.fromMap(e.data(), e.id))
        .toList();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTeacherCourses() {
    return courses.where("owner", isEqualTo: currentUser!.uid).snapshots();
  }

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
              materials: cw.materials,
              assignmentId: cw.id!,
              title: cw.title!,
              duration: 0,
              docId: ""));
        }
      }
      return list + assignmets;
    }
    return [];
  }

  Future<List<DocumentReference<Map<String, dynamic>>>>
      insertAssignmentCopyForStudents(AssignmentModel assignment,
          CourseModel course, List<String> materials) async {
    List<DocumentReference<Map<String, dynamic>>> ids = [];
    for (var student in course.students) {
      final doc = await FirebaseFirestore.instance.collection('Schedule').add({
        "studentId": student,
        "note": assignment.note,
        "type": "assignment",
        "date": DateTime(2100),
        "index": 100,
        "time": assignment.duration,
        "times": [],
        "indexes": [],
        "finishedList": [],
        "dates": [],
        "title": assignment.title,
        "dueDate": assignment.dueDate ??
            DateUtils.dateOnly(
              DateTime.now().add(
                const Duration(days: 7),
              ),
            ),
        "materials": materials
      });
      ids.add(FirebaseFirestore.instance.doc("Schedule/${doc.id}"));
    }
    return ids;
  }

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
      assignments.doc(assignment.docId).get().then((value) async {
        if (value.exists) {
          assignments.doc(assignment.docId).update({
            "note": assignment.note,
            "duration": assignment.duration,
            "dueDate": assignment.dueDate ??
                DateTime.now().add(const Duration(days: 17))
          });
        } else {
          final List<String> materials = getMaterials(assignment.materials);
          final ids = await insertAssignmentCopyForStudents(
              assignment, course, materials);

          assignment.studentsCopy = ids
              .map((e) => FirebaseFirestore.instance.doc("Schedule/$e"))
              .toList();
          assignments
              .add(assignment.toMap())
              .then((value) => assignment.docId = value.id);
        }
      });
    } else {
      final List<String> materials = getMaterials(assignment.materials);
      final ids =
          await insertAssignmentCopyForStudents(assignment, course, materials);

      assignment.studentsCopy = ids;
      assignments
          .add(assignment.toMap())
          .then((value) => assignment.docId = value.id);
    }
  }

  Future<List<ReminderModel>> getTeacherRemider(String id) async {
    return (await FirebaseFirestore.instance
            .collection('Reminders')
            .where("classId", isEqualTo: id)
            .get())
        .docs
        .map((e) => ReminderModel.fromMap(e.data(), e.id))
        .toList();
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

  Future<ReminderModel> addReminder(
      {required String classId,
      required DateTime date,
      required String title}) async {
    final ids = await addRemindersCopyForStudents(
        classId: classId, date: date, title: title);
    final doc = await reminder.add({
      "classId": classId,
      "date": DateUtils.dateOnly(date),
      "title": title,
      "studentsCopy":
          ids.map((e) => FirebaseFirestore.instance.doc("Schedule/$e")).toList()
    });
    return ReminderModel(
        classId: classId,
        date: Timestamp.fromDate(date),
        docId: doc.id,
        studentsCopy: ids
            .map((e) => FirebaseFirestore.instance.doc("Schedule/$e"))
            .toList(),
        title: title);
  }

  void updateReminder({required ReminderModel r}) {
    reminder.doc(r.docId).update({
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

  Future<List<PopUpModel>> getTeacherPopUps(String id) async {
    return (await popups.where("classId", isEqualTo: id).get())
        .docs
        .map(
          (e) => PopUpModel.fromMap(e.data(), e.id),
        )
        .toList();
  }

  Future<PopUpModel> addPopUp(
      {required String classId,
      required String courseId,
      required DateTime date,
      required String title,
      required List<String> students,
      required String cm}) async {
    final p = await popups.add({
      "classId": classId,
      "dueDate": DateUtils.dateOnly(date),
      "title": title,
      "numRate": 0,
      "sumRate": 0,
      "question": cm,
      "order": DateUtils.dateOnly(DateTime.now()),
      "students": students
    });
    return PopUpModel.fromMap({
      "classId": classId,
      "dueDate": Timestamp.fromDate(DateUtils.dateOnly(date)),
      "title": title,
      "numRate": 0,
      "sumRate": 0,
      "question": cm,
      "order": DateUtils.dateOnly(DateTime.now()),
      "students": students
    }, p.id);
  }

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

  void addCourse({required google_api.Course course}) {
    FirebaseFirestore.instance.collection('Courses').add({
      "id": course.id,
      "code": course.enrollmentCode,
      "name": course.name,
      "owner": currentUser!.uid,
      "students": []
    });
    addCourseToUser(course.id!);
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

  Future<List<ExtracurricularModel>> getExtracurriculars() async {
    return (await schedule
            .where("studentId", isEqualTo: currentUser!.uid)
            .where("type", isEqualTo: "extracurricular")
            .get())
        .docs
        .map((e) => ExtracurricularModel.fromMap(e.data(), e.id))
        .toList();
  }

  Future<ExtracurricularModel> addExtracurricular(
      {required String title, required int time, required int day}) async {
    final doc = await FirebaseFirestore.instance.collection('Schedule').add({
      "title": title,
      "time": time,
      "dayIndex": day,
      "studentId": currentUser!.uid,
      "type": "extracurricular",
      "index": 1000,
      "date": null
    });
    currentUser!.extracurricularsTimes[day] += time;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .update({"extracurricularsTimes": currentUser!.extracurricularsTimes});
    return ExtracurricularModel.fromMap({
      "title": title,
      "time": time,
      "dayIndex": day,
      "studentId": currentUser!.uid,
      "type": "extracurricular",
      "index": 1000,
      "date": null
    }, doc.id);
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
      "date": DateUtils.dateOnly(date),
      "title": title,
      "type": "reminder",
      "index": -1
    });
  }

  void deleteExtracurriculars(ExtracurricularModel ex) {
    FirebaseFirestore.instance.collection('Schedule').doc(ex.docId).delete();
    currentUser!.extracurricularsTimes[ex.dayIndex] -= ex.time;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .update({"extracurricularsTimes": currentUser!.extracurricularsTimes});
  }

  void updateExtracurriculars(
      ExtracurricularModel ex, int prevIndex, int prevTime) {
    FirebaseFirestore.instance
        .collection('Schedule')
        .doc(ex.docId)
        .update(ex.toMap());
    currentUser!.extracurricularsTimes[ex.dayIndex] += ex.time;
    currentUser!.extracurricularsTimes[prevIndex] -= prevTime;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .update({"extracurricularsTimes": currentUser!.extracurricularsTimes});
  }

  Future<List<CourseModel>> getStudentCourses() async {
    return (await courses
            .where("students", arrayContains: currentUser!.uid)
            .get())
        .docs
        .map((e) => CourseModel.fromMap(e.data(), e.id))
        .toList();
  }

  Future<CourseModel?> getCourse({
    required String code,
  }) async {
    final doc = (await courses.where('code', isEqualTo: code).get()).docs;
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
        inspect(c);
        if (c != null) {
          name = c.name;
          final baseClient = Client();
          final authenticateClient = AuthenticateClient(
              await googleSignIn.currentUser!.authHeaders, baseClient);
          final cra = google_api.ClassroomApi(authenticateClient);
          addCourseToUser(c.docid);
          addUserToCourse(c.docid);
          await cra.courses.students.create(
              google_api.Student(userId: 'me'), c.courseId,
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
//bzlg7r5
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
