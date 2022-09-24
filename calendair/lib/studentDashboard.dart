import 'dart:developer';
import 'package:calendair/classes/firestore.dart';
import 'package:calendair/bottomNavBar.dart';
import 'package:calendair/breakDay.dart';
import 'package:calendair/classes.dart';
import 'package:calendair/confidenceMeter.dart';
import 'package:calendair/extracurriculars.dart';
import 'package:calendair/models/PopUpModel.dart';
import 'package:calendair/settings.dart' as c;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'classes/googleClassroom.dart';
import 'dashboard.dart';
import 'models/nbar.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool open = true;
  final gc = Get.find<GoogleClassroom>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavBar(
        items: [
          NBar(
              slika: 'calendar',
              onclick: () {
                Get.to(
                  const Dashboard(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              }),
          NBar(
              slika: 'home',
              // widget: const studentDashboard(),
              onclick: () {
                setState(() {
                  open = true;
                });
              }),
          NBar(
              slika: 'settings',
              onclick: () {
                Get.to(
                  const c.Settings(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              })
        ],
        selected: 1,
      ),
      body: SafeArea(
        child: SizedBox(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SizedBox(
                        width: 70.w,
                        child: const FittedBox(
                          child: Text(
                            'Dashboard',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        width: 70.w,
                        height: 80,
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
                              const Classes(),
                              transition: Transition.circularReveal,
                              duration: const Duration(milliseconds: 800),
                            );
                          },

                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Classes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ), // <-- Text
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 70.w,
                        height: 80,
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
                              const Extracurriculars(),
                              transition: Transition.circularReveal,
                              duration: const Duration(milliseconds: 800),
                            );
                          },

                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Extracurriculars',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ), // <-- Text
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 70.w,
                        height: 80,
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
                              const BreakDay(),
                              transition: Transition.circularReveal,
                              duration: const Duration(milliseconds: 800),
                            );
                          },

                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Breakday',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ), // <-- Text
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (open)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 90.w,
                    height: 77.h,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(26, 71, 97, 0.9),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Container()),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      open = !open;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          const FittedBox(
                            child: Text(
                              'Pop-Ups',
                              style: TextStyle(
                                  fontSize: 50,
                                  color: Color.fromRGBO(171, 223, 252, 1),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                          Expanded(
                            child: StreamBuilder(
                                stream: Firestore().getStudentPopUps(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    inspect(snapshot.data);
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ...snapshot.data!.docs.map((e) {
                                            final pu = PopUpModel.fromMap(
                                              e.data() as Map<String, dynamic>,
                                            );
                                            return InkWell(
                                              onTap: () {
                                                Get.to(
                                                  ConfidenceMeter(
                                                      id: e.id,
                                                      question:
                                                          "${DateFormat("MM/dd/yy").format(pu.dueDate.toDate())} ${pu.title}",
                                                      message: pu.question),
                                                  transition:
                                                      Transition.circularReveal,
                                                  duration: const Duration(
                                                      milliseconds: 800),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                child: SizedBox(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.asset(
                                                          'assets/images/triangle.png',
                                                          width: 15,
                                                          height: 15,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 65.w,
                                                        child: Text(
                                                          "${DateFormat("MM/dd/yy").format(pu.dueDate.toDate())} ${pu.title}",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList()
                                        ],
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ), // ],
        ),
      ),
    );
  }
}
