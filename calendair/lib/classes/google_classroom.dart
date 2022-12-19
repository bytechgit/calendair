import 'dart:developer';

import 'package:calendair/classes/authentication.dart';
import 'package:calendair/models/assignment_model.dart';
import 'package:calendair/teacher/pop_ups.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:http/http.dart';

class GoogleClassroom with ChangeNotifier {
  String confidence = "";
  bool edit = false;
  List<Course> courses = [];
  List<Student> students = [];
  List<MyAssignment> assignments = [];
  List<PopUps> popups = [];
  UserAuthentication userAuthentication;
  GoogleClassroom(this.userAuthentication);
  Future<List<Course>> getCourseList() async {
    if (userAuthentication.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await userAuthentication.googleSignIn.currentUser!.authHeaders,
          baseClient);
      final cra = ClassroomApi(authenticateClient);
      Map<String, dynamic>? data = await userAuthentication
          .readUser(userAuthentication.auth.currentUser!.uid);
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
        return [];
      }
    } else {
      return [];
    }
  }

  void addClass(Course c) {
    userAuthentication.addCourse(
        classId: c.id!, code: c.enrollmentCode!, name: c.name!);
  }

  Future<void> updateAssignment(
      {required int index,
      required String note,
      required String min,
      required String courseId}) async {
    assignments[index].note = note;
    assignments[index].duration = int.tryParse(min) ?? 0;
    assignments;
    userAuthentication.insertOrUpdateAssignment(assignments[index], courseId);
    notifyListeners();
  }

  Future<void> getStudentsList(String courseId) async {
    students = [];
    if (userAuthentication.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await userAuthentication.googleSignIn.currentUser!.authHeaders,
          baseClient);
      final cra = ClassroomApi(authenticateClient);
      students = (await cra.courses.students.list(courseId)).students ?? [];
    }
  }

  Future<List<MyAssignment>> getAssigmentsList(String courseId) async {
    assignments = [];
    if (userAuthentication.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await userAuthentication.googleSignIn.currentUser!.authHeaders,
          baseClient);
      final cra = ClassroomApi(authenticateClient);
      for (var c
          in ((await cra.courses.courseWork.list(courseId)).courseWork ?? [])) {
        MyAssignment mya = await userAuthentication.readMyAssignment(c);
        mya.coursework = c;
        assignments.add(mya);
      }

      return assignments;
    }
    return [];
  }

  Future<String> createCourse(String name, String period) async {
    if (userAuthentication.googleSignIn.currentUser != null) {
      final baseClient = Client();
      final authenticateClient = AuthenticateClient(
          await userAuthentication.googleSignIn.currentUser!.authHeaders,
          baseClient);
      final cra = ClassroomApi(authenticateClient);

      final c = await cra.courses.create(Course(name: name, ownerId: 'me'));
      userAuthentication.addCourse(
          classId: c.id!, code: c.enrollmentCode!, name: c.name!);
      return c.enrollmentCode!;
    }
    return "";
  }

  Future<String> enrolToCourse(String code) async {
    if (userAuthentication.googleSignIn.currentUser != null) {
      String name = "";
      try {
        final c = await userAuthentication.getCourse(code: code);
        inspect(c);
        if (c.docs.isNotEmpty) {
          String docId = c.docs[0].id;
          String id = c.docs[0]["id"];
          name = c.docs[0]["name"];
          final baseClient = Client();
          final authenticateClient = AuthenticateClient(
              await userAuthentication.googleSignIn.currentUser!.authHeaders,
              baseClient);
          final cra = ClassroomApi(authenticateClient);
          userAuthentication.addCourseToUser(docId);
          userAuthentication.addUserToCourse(docId);
          final cur = await cra.courses.students
              .create(Student(userId: 'me'), id, enrollmentCode: code);
          return name;
        } else {
          return "";
        }
      } on DetailedApiRequestError catch (e) {
        if (e.status == 409) {
          return name;
        }
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
  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return client.send(request..headers.addAll(headers));
  }
}
