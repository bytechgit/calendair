import 'package:calendair/Classes/firestore.dart';
import 'package:calendair/bottomNavBar.dart';
import 'package:calendair/breakDay.dart';
import 'package:calendair/calendar.dart';
import 'package:calendair/classes.dart';
import 'package:calendair/confidenceMeter.dart';
import 'package:calendair/extracurriculars.dart';
import 'package:calendair/settings.dart' as c;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';

import 'Classes/googleClassroom.dart';
import 'dashboard.dart';
import 'loginRegister.dart';
import 'models/nbar.dart';

class studentDashboard extends StatefulWidget {
  const studentDashboard({Key? key}) : super(key: key);

  @override
  State<studentDashboard> createState() => _studentDashboardState();
}

class _studentDashboardState extends State<studentDashboard> {
  bool selected = false;
  final gc = Get.find<GoogleClassroom>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
            widget: const dashboard(),
          ),
          NBar(
            slika: 'home',
          ),
          NBar(
            slika: 'settings',
            widget: const c.Settings(),
          )
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
                    width: width * 0.7,
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
                    width: width * 0.70,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      onPressed: () {
                        Get.to(
                          const classes(),
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
                    width: width * 0.70,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: const Color.fromRGBO(94, 159, 197, 1),
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
                    width: width * 0.70,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: const Color.fromRGBO(94, 159, 197, 1),
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
          if (!selected)
            Align(
              alignment: Alignment.center,
              child: Container(
                width: width * 0.9,
                height: height * 0.77,
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
                                  selected = !selected;
                                });

                                print(selected);
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
                        child: Obx(
                          () => StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Popups')
                                  .where("ClassId",
                                      whereIn: gc.courses.value.isEmpty
                                          ? ["aa"]
                                          : gc.courses.value
                                              .map((e) => e.id)
                                              .toList())
                                  .where("students")
                                  .orderBy("order")
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ...snapshot.data!.docs.reversed
                                            .where((element) =>
                                                !(element["students"]
                                                        as List<dynamic>)
                                                    .map((e) => e.toString())
                                                    .toList()
                                                    .contains(Firestore()
                                                        .ua
                                                        .currentUser!
                                                        .uid))
                                            .map(
                                              (d) => InkWell(
                                                onTap: () {
                                                  Get.to(
                                                    ConfidenceMeter(
                                                      id: d.id,
                                                      question: d["Date"] +
                                                          " " +
                                                          d["Title"],
                                                      message: d[
                                                          "ConfidenceQuestion"],
                                                    ),
                                                    transition: Transition
                                                        .circularReveal,
                                                    duration: const Duration(
                                                        milliseconds: 800),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: SizedBox(
                                                    height: 40,
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
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.55,
                                                          child: FittedBox(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            child: Text(
                                                              d["Date"] +
                                                                  " " +
                                                                  d["Title"],
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList()
                                      ],
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ) // ],
              )),
    );
  }
}
