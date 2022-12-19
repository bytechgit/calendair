import 'dart:developer';

import 'package:calendair/models/course_model.dart';
import 'package:calendair/models/extracurricular_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/schedule/scheduleElement.dart';

class StudentState with ChangeNotifier {
  List<ExtracurricularModel>? extracurriculars;
  List<CourseModel>? courses;
  void addExtracurricular(ExtracurricularModel extracurricular) {
    extracurriculars?.add(extracurricular);
    notifyListeners();
  }

  void addExtracurriculars(List<ExtracurricularModel> extracurriculars) {
    this.extracurriculars = extracurriculars;
    notifyListeners();
  }

  void addCourse(CourseModel course) {
    courses?.add(course);
    notifyListeners();
  }

  void addCourses(List<CourseModel> courses) {
    this.courses = courses;
    notifyListeners();
  }

  void deleteExtracurricular(ExtracurricularModel extracurricular) {
    extracurriculars?.remove(extracurricular);
    notifyListeners();
  }
}
