import 'package:calendair/classes/firestore.dart';
import 'package:calendair/teacher/class_dashboard.dart';
import 'package:calendair/teacher/make_class.dart';
import 'package:calendair/models/CustomCourse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../classes/googleClassroom.dart';
import '../student_teacher/bottom_nav_bar.dart';
import '../models/nbar.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  changeTabIndex(int i) {}
  final gc = Get.find<GoogleClassroom>();
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavBar(
        items: [
          NBar(
              slika: 'home',
              onclick: () {
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/TeacherDashboard');
              }),
        ],
        selected: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: 50.w,
                  child: const FittedBox(
                    child: Text(
                      'Classes',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(223, 223, 223, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Stack(
                      children: [
                        StreamBuilder(
                            stream: Firestore().getTeacherCourses(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return SingleChildScrollView(
                                  child: Column(children: [
                                    ...snapshot.data!.docs.map((e) {
                                      final cc = CustomCourse.fromMap(
                                          e.data() as Map<String, dynamic>,
                                          e.id);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: InkWell(
                                          onTap: (() {
                                            Get.to(
                                              ClassDashboard(
                                                course: cc,
                                              ),
                                              transition:
                                                  Transition.circularReveal,
                                              duration: const Duration(
                                                  milliseconds: 800),
                                            );
                                          }),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    94, 159, 197, 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            height: 65,
                                            child: Center(
                                              child: FittedBox(
                                                child: Text(
                                                  cc.name,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        38, 65, 78, 1),
                                                    fontSize: 36,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 100,
                                      ),
                                    ),
                                  ]),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: 40.w,
                              height: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shadowColor:
                                        const Color.fromRGBO(247, 247, 247, 1),
                                    backgroundColor:
                                        const Color.fromRGBO(94, 159, 197, 1),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                onPressed: () {
                                  Get.to(
                                    const MakeClass(),
                                    transition: Transition.circularReveal,
                                    duration: const Duration(milliseconds: 800),
                                  );
                                },
                                child: const Text(
                                  'Make a class',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ), // <-- Text
                              ),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-15, 20),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: SizedBox(
                                width: 40.w,
                                child: Image.asset(
                                    'assets/images/teacherDashboard.png')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
