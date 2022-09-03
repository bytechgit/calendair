import 'dart:developer';

import 'package:calendair/extracurricularsAdd.dart';
import 'package:calendair/rate.dart';
import 'package:calendair/studentDashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import 'Classes/googleClassroom.dart';
import 'addClass.dart';
import 'bottomNavBar.dart';
import 'calendar.dart';
import 'dashboard.dart';
import 'models/nbar.dart';
import 'settings.dart';

class Extracurriculars extends StatefulWidget {
  const Extracurriculars({Key? key}) : super(key: key);

  @override
  State<Extracurriculars> createState() => _ExtracurricularsState();
}

class _ExtracurricularsState extends State<Extracurriculars> {
  final gc = Get.find<GoogleClassroom>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
            //inspect(gc.courses);
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        items: [
          NBar(
              slika: 'calendar',
              onclick: () {
                Get.off(
                  dashboard(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              }),
          NBar(
              slika: 'home',
              onclick: () {
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/studentDashboard');
              }),
          NBar(
              slika: 'settings',
              onclick: () {
                Get.off(
                  Settings(),
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
                padding: const EdgeInsets.only(top: 10.0, bottom: 30),
                child: SizedBox(
                  width: width * 0.7,
                  child: const FittedBox(
                    child: Text(
                      'Extracurriculars',
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
                flex: 8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < 5; i++)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          height: 65,
                          child: Row(children: [
                            SizedBox(
                              width: width * 0.5,
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Extracurriculars',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                              flex: 2,
                            ),
                            SizedBox(
                              width: width * 0.30,
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shadowColor:
                                        const Color.fromRGBO(247, 247, 247, 1),
                                    primary:
                                        const Color.fromRGBO(94, 159, 197, 1),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )),
                                onPressed: () {
                                  Get.to(
                                    const ExtracurricularsAdd(),
                                    transition: Transition.circularReveal,
                                    duration: const Duration(milliseconds: 800),
                                  );
                                },

                                child: const Text(
                                  'Edit',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                  ),
                                ), // <-- Text
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                              flex: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/remove.png',
                                height: 35,
                              ),
                            )
                          ]),
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SizedBox(
                  width: width * 0.70,
                  height: 75,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                        primary: const Color.fromRGBO(94, 159, 197, 1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                    onPressed: () {
                      Get.to(
                        const ExtracurricularsAdd(),
                        transition: Transition.circularReveal,
                        duration: const Duration(milliseconds: 800),
                      );
                    },

                    child: const Text(
                      'Add Programs/Extracurriculars',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                      ),
                    ), // <-- Text
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
