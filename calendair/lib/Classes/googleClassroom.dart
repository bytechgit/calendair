import 'dart:developer';

import 'package:calendair/Classes/Authentication.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:http/http.dart';

class GoogleClassroom extends GetxController {
  GoogleClassroom();
  final edit = false.obs;
  final courses = Rx<List<Course>>([]);
  final students = Rx<List<Student>>([]);
  final assignments = Rx<List<CourseWork>>([]);
  final ua = UserAuthentication();
  Future<void> getCourseList() async {
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);
      courses.value = (await cra.courses.list()).courses ?? [];
      inspect(courses);
      courses.refresh();
    }
  }

  Future<void> getStudentsList(String courseId) async {
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

  Future<void> getAssigmentsList(String courseId) async {
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);

      assignments.value =
          (await cra.courses.courseWork.list(courseId)).courseWork ?? [];
      inspect(students);
      courses.refresh();
    }
  }

  Future<void> createCourse() async {
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);

      final c =
          await cra.courses.create(Course(name: 'proba kurs', ownerId: 'me'));
      inspect(c);
    }
  }

  Future<void> joinCourse(String courseId) async {
    if (ua.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await ua.googleSignIn.currentUser!.authHeaders, baseClient);
      final cra = ClassroomApi(authenticateClient);

      final c = await cra.courses.students.create(
          Student(userId: 'me'), '544383080444',
          enrollmentCode: "rrwzs42");
      inspect(c);
    }
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
