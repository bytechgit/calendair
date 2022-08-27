import 'package:calendair/assignments.dart';
import 'package:calendair/popUps.dart';
import 'package:calendair/reminders.dart';
import 'package:calendair/students.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'bottomNavBar.dart';
import 'models/nbar.dart';

class DashboardPeriod extends StatefulWidget {
  const DashboardPeriod({Key? key}) : super(key: key);

  @override
  State<DashboardPeriod> createState() => _DashboardPeriodState();
}

class _DashboardPeriodState extends State<DashboardPeriod> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
      bottomNavigationBar: BottomNavBar(
        items: [
          NBar(
            slika: 'home',
          ),
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
                  width: width * 0.5,
                  child: const FittedBox(
                    child: Text(
                      'Period 1',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.8,
                child: const Divider(
                  thickness: 10,
                  height: 15,
                  color: Color.fromRGBO(223, 223, 223, 1),
                ),
              ),
              const Text(
                'JOIN CODE: 000-000',
                style: TextStyle(
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
                          const Students(),
                          transition: Transition.circularReveal,
                          duration: const Duration(milliseconds: 800),
                        );
                      }),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
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
                          const Assignments(),
                          transition: Transition.circularReveal,
                          duration: const Duration(milliseconds: 800),
                        );
                      }),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
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
                          const Reminders(),
                          transition: Transition.circularReveal,
                          duration: const Duration(milliseconds: 800),
                        );
                      }),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
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
                          const PopUps(),
                          transition: Transition.circularReveal,
                          duration: const Duration(milliseconds: 800),
                        );
                      }),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
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
