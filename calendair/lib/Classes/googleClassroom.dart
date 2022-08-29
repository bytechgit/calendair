import 'dart:developer';

import 'package:calendair/Classes/Authentication.dart';
import 'package:calendair/models/Assigments.dart';
import 'package:calendair/popUps.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:http/http.dart';

import 'firestore.dart';

class GoogleClassroom extends GetxController {
  GoogleClassroom();
  String confidence = "";
  final edit = false.obs;
  final courses = Rx<List<Course>>([]);
  final students = Rx<List<Student>>([]);
  final assignments = Rx<List<CourseWork>>([]);
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

  Future<List<Course>> getCourseList() async {
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);

      Map<String, dynamic>? data =
          await Firestore().readUser(ua.auth.currentUser!.uid);
      if (data != null) {
        final lcr = await cra.courses.list(teacherId: "me");
        return lcr.courses != null
            ? lcr.courses!
                .where((Course course) => !(data["classes"] as List<dynamic>)
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
    courses.value.add(c);
    Firestore().addClassToUser(c.id!);
    courses.refresh();
  }

  Future<void> updateAssignment(CourseWork cw) async {
    final baseClient = Client();
    final authenticateClient = AuthenticateClient(
        await ua.googleSignIn.currentUser!.authHeaders, baseClient);
    final cra = ClassroomApi(authenticateClient);
    cra.courses.courseWork
        .patch(cw, cw.courseId!, cw.id!, updateMask: 'dueTime,dueDate');
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

  Future<List<CourseWork>> getAssigmentsList(String courseId) async {
    assignments.value = [];
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);

      assignments.value =
          (await cra.courses.courseWork.list(courseId)).courseWork ?? [];
      return assignments.value;
    }
    return [];
  }

  Future<void> getCourseListTeacher() async {
    courses.value = [];
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);
      print(ua.auth.currentUser!.uid);
      Map<String, dynamic>? data =
          await Firestore().readUser(ua.auth.currentUser!.uid);
      print("aaaa");
      inspect(data!['uid']);
      if (data != null) {
        cra.courses.list(teacherId: "me").then((ListCoursesResponse lcr) {
          courses.value = lcr.courses != null
              ? lcr.courses!
                  .where((Course course) => (data["classes"] as List<dynamic>)
                      .map((e) => e.toString())
                      .toList()
                      .contains(course.id))
                  .toList()
              : [];
          courses.refresh();
        });
      }
    }
  }

  Future<void> getCourseListStudent() async {
    courses.value = [];
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);
      courses.value = (await cra.courses.list(studentId: 'me')).courses ?? [];
      courses.refresh();
    }
  }

  Future<String> createCourse(String name, String period) async {
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);

      final c = await cra.courses.create(Course(name: name, ownerId: 'me'));
      inspect(c);
      Firestore().addClassToUser(c.id!);
      courses.value.add(c);
      courses.refresh();
      Firestore()
          .addcourse(classId: c.id!, code: c.enrollmentCode!, name: c.name!);
      return c.enrollmentCode!;
    }
    Get.snackbar("Login", "You are not logged in");
    return "";
  }

  Future<String> enrolToCourse(String code) async {
    if (ua.googleSignIn.currentUser != null) {
      final c = await Firestore().getcourse(code: code);
      if (c.docs.length > 0) {
        String id = c.docs[0]["id"];
        String name = c.docs[0]["name"];
        print(id);
        print(name);
        final baseClient = Client();
        final authenticateClient = AuthenticateClient(
            await ua.googleSignIn.currentUser!.authHeaders, baseClient);
        final cra = ClassroomApi(authenticateClient);

        final cur = await cra.courses.students
            .create(Student(userId: 'me'), id, enrollmentCode: code);

        courses.value.add(await cra.courses.get(id));
        courses.refresh();
        inspect(c);
        return name;
      } else {
        Get.snackbar("", "The course does not exist");
        return "";
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
