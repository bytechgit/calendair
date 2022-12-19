import 'package:calendair/classes/authentication.dart';
import 'package:calendair/student/add_class.dart';
import 'package:calendair/models/custom_course.dart';
import 'package:calendair/student/rate_class_strength.dart';
import 'package:calendair/student/settings.dart' as s;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../student_teacher/bottom_nav_bar.dart';
import 'dashboard.dart';
import '../models/nbar.dart';

class Classes extends StatefulWidget {
  const Classes({Key? key}) : super(key: key);
  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  late final UserAuthentication userAuthentication;
  @override
  void initState() {
    userAuthentication = context.read<UserAuthentication>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: BottomNavBar(
        items: [
          NBar(
              slika: 'calendar',
              onclick: () {
                Get.off(
                  const Dashboard(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              }),
          NBar(
              slika: 'home',
              onclick: () {
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/StudentDashboard');
              }),
          NBar(
              slika: 'settings',
              onclick: () {
                Get.off(
                  const s.Settings(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              })
        ],
        selected: 1,
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
                            stream: userAuthentication.getStudentCourses(),
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
                                          onTap: (() {}),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    94, 159, 197, 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            height: 65,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 50.w,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        cc.name,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              38, 65, 78, 1),
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(child: Container()),
                                                GestureDetector(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: Image.asset(
                                                      'assets/images/settings.png',
                                                      width: 30,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Get.to(
                                                      RateClassStrength(
                                                        name: cc.name,
                                                        back3: false,
                                                      ),
                                                      transition: Transition
                                                          .circularReveal,
                                                      duration: const Duration(
                                                          milliseconds: 800),
                                                    );
                                                  },
                                                )
                                              ],
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
                                    const AddClass(),
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





/////
///
