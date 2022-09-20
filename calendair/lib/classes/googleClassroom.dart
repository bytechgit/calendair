import 'dart:developer';
import 'package:calendair/classes/Authentication.dart';
import 'package:calendair/models/AssignmentModel.dart';
import 'package:calendair/popUps.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:http/http.dart';
import 'package:quiver/iterables.dart';

import 'firestore.dart';

class GoogleClassroom extends GetxController {
  GoogleClassroom();
  String confidence = "";
  final edit = false.obs;
  final courses = Rx<List<Course>>([]);
  final students = Rx<List<Student>>([]);
  final assignments = Rx<List<MyAssignment>>([]);
  final popups = Rx<List<PopUps>>([]);
  final ua = UserAuthentication();

  // Future<void> getCourseList() async {
  //   if (ua.googleSignIn.currentUser != null) {
  //     final baseClient = Client();
  //     final authenticateClient = AuthenticateClient(
  //         await ua.googleSignIn.currentUser!.authHeaders, baseClient);
  //     final cra = ClassroomApi(authenticateClient);
  //     courses.value = (await cra.courses.list()).courses ?? [];
  //     inspect(courses);
  //     courses.refresh();
  //   }
  // }
  Iterable<MapEntry<int, List<Course>>> getPartiotion() {
    return partition(courses.value, 10).toList().asMap().entries;
  }

  Future<List<Course>> getCourseList() async {
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);
      print("aaaa");
      Map<String, dynamic>? data =
          await Firestore().readUser(ua.auth.currentUser!.uid);
      if (data != null) {
        final lcr = await cra.courses.list(teacherId: "me");
        return lcr.courses != null
            ? lcr.courses!
                .where((Course course) => !(data["courses"] as List<dynamic>)
                    .map((e) => e.toString())
                    .toList()
                    .contains(course.id))
                .toList()
            : [];
      } else {
        print("dsfas");
        return [];
      }
    } else {
      Get.snackbar("Login", "You are not logged in");
      return [];
    }
  }

  void addClass(Course c) {
    //courses.value.add(c);
    Firestore()
        .addCourse(classId: c.id!, code: c.enrollmentCode!, name: c.name!);
    // courses.refresh();
  }

  Future<void> updateAssignment(MyAssignment mya) async {
    // final baseClient = Client();
    // final authenticateClient = AuthenticateClient(
    //     await ua.googleSignIn.currentUser!.authHeaders, baseClient);
    // final cra = ClassroomApi(authenticateClient);
    // cra.courses.courseWork
    //     .patch(mya.coursework!, mya.coursework!.courseId!, mya.coursework!.id!, updateMask: 'description');
  }

  Future<void> getStudentsList(String courseId) async {
    students.value = [];
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);

      students.value =
          (await cra.courses.students.list(courseId)).students ?? [];
      inspect(students);
      courses.refresh();
    }
  }

  Future<List<MyAssignment>> getAssigmentsList(String courseId) async {
    assignments.value = [];
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);
      print("LOAD ASSIGNMENTS");
      for (var c
          in ((await cra.courses.courseWork.list(courseId)).courseWork ?? [])) {
        print(c.title);
        MyAssignment mya = await Firestore().readMyAssignment(c);

        print(c.title);
        mya.coursework = c;
        assignments.value.add(mya);
      }

      return assignments.value;
    }
    return [];
  }

  // Future<int> getCourseListTeacher() async {
  //   if (courses.value.isNotEmpty) return 1;
  //   courses.value = [];
  //   if (ua.googleSignIn.currentUser != null) {
  //     final baseClient = Client();
  //     final authenticateClient = AuthenticateClient(
  //         await ua.googleSignIn.currentUser!.authHeaders, baseClient);
  //     final cra = ClassroomApi(authenticateClient);
  //     print(ua.auth.currentUser!.uid);
  //     Map<String, dynamic>? data =
  //         await Firestore().readUser(ua.auth.currentUser!.uid);
  //     if (data != null) {
  //       final lcr = await cra.courses.list(teacherId: "me");
  //       courses.value = lcr.courses != null
  //           ? lcr.courses!
  //               .where((Course course) => (data["classes"] as List<dynamic>)
  //                   .map((e) => e.toString())
  //                   .toList()
  //                   .contains(course.id))
  //               .toList()
  //           : [];
  //       courses.refresh();
  //     }
  //   }
  //   return 2;
  // }

  // Future<void> getCourseListStudent() async {
  //   courses.value = [];
  //   if (ua.googleSignIn.currentUser != null) {
  //     final baseClient = Client();
  //     final authenticateClient = AuthenticateClient(
  //         await ua.googleSignIn.currentUser!.authHeaders, baseClient);
  //     final cra = ClassroomApi(authenticateClient);
  //     courses.value = (await cra.courses.list(studentId: 'me')).courses ?? [];
  //     courses.refresh();
  //   }
  // }

  Future<String> createCourse(String name, String period) async {
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);

      final c = await cra.courses.create(Course(name: name, ownerId: 'me'));
      Firestore()
          .addCourse(classId: c.id!, code: c.enrollmentCode!, name: c.name!);
      return c.enrollmentCode!;
    }
    Get.snackbar("Login", "You are not logged in");
    return "";
  }

  Future<String> enrolToCourse(String code) async {
    if (ua.googleSignIn.currentUser != null) {
      try {
        final c = await Firestore().getCourse(code: code);
        if (c.docs.isNotEmpty) {
          String docId = c.docs[0].id;
          String id = c.docs[0]["id"];
          String name = c.docs[0]["name"];
          final baseClient = Client();
          final authenticateClient = AuthenticateClient(
              await ua.googleSignIn.currentUser!.authHeaders, baseClient);
          final cra = ClassroomApi(authenticateClient);

          final cur = await cra.courses.students
              .create(Student(userId: 'me'), id, enrollmentCode: code);
          Firestore().addCourseToUser(docId);
          Firestore().addUserToCourse(docId);
          return name;
        } else {
          Get.snackbar("", "The course does not exist");
          return "";
        }
      } on DetailedApiRequestError catch (e) {
        print(e);
        Get.snackbar("Error", e.message ?? "");
      }
    }
    return "Error";
  }
}

class AuthenticateClient extends BaseClient {
  final Map<String, String> headers;

  final Client client;

  AuthenticateClient(this.headers, this.client);

  Future<StreamedResponse> send(BaseRequest request) {
    return client.send(request..headers.addAll(headers));
  }
}
