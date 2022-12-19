import 'package:calendair/models/course_model.dart';
import 'package:calendair/student_teacher/bottom_nav_bar.dart';
import 'package:calendair/teacher/pop_ups.dart';
import 'package:calendair/teacher/reminders.dart';
import 'package:calendair/teacher/students.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'assignments.dart';

class ClassDashboar extends StatelessWidget {
  final CourseModel course;
  const ClassDashboar({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      bottomNavigationBar: NavBar(
        navBarItems: [
          NavBarItem(
              image: 'home',
              onclick: () {
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/TeacherDashboard');
              }),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: 80.w,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      course.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 80.w,
                child: const Divider(
                  thickness: 10,
                  height: 15,
                  color: Color.fromRGBO(223, 223, 223, 1),
                ),
              ),
              Text(
                'JOIN CODE: ${course.code}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: InkWell(
                      onTap: (() {
                        Get.to(
                          Students(courseId: course.docid),
                        );
                      }),
                      child: SizedBox(
                        height: 60,
                        width: 80.w,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Students",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
                                    fontSize: 50,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(0, -3),
                              child: const Align(
                                alignment: Alignment.bottomLeft,
                                child: Divider(
                                  thickness: 10,
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: InkWell(
                      onTap: (() {
                        Get.to(
                          Assignments(
                            course: course,
                          ),
                        );
                      }),
                      child: SizedBox(
                        height: 60,
                        width: 80.w,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Assignments",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
                                    fontSize: 50,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(0, -3),
                              child: const Align(
                                alignment: Alignment.bottomLeft,
                                child: Divider(
                                  thickness: 10,
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: InkWell(
                      onTap: (() {
                        Get.to(
                          Reminders(course: course),
                        );
                      }),
                      child: SizedBox(
                        height: 60,
                        width: 180.w,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Reminders",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
                                    fontSize: 50,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(0, -3),
                              child: const Align(
                                alignment: Alignment.bottomLeft,
                                child: Divider(
                                  thickness: 10,
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: InkWell(
                      onTap: (() {
                        Get.to(
                          PopUps(course: course),
                        );
                      }),
                      child: SizedBox(
                        height: 60,
                        width: 80.w,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Pop-Ups",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
                                    fontSize: 50,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(0, -3),
                              child: const Align(
                                alignment: Alignment.bottomLeft,
                                child: Divider(
                                  thickness: 10,
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
