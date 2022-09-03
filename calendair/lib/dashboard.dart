import 'package:calendair/settings.dart';
import 'package:calendair/studentDashboard.dart';
import 'package:calendair/toDo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottomNavBar.dart';
import 'calendar.dart';
import 'models/nbar.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
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
            //const Color.fromRGBO(93, 159, 196, 1),

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
                          (route as GetPageRoute).routeName ==
                          '/studentDashboard');
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
              selected: 0,
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 0),
                          child: InkWell(
                            onTap: (() {
                              Get.to(
                                const ToDo(
                                  day: "Monday",
                                ),
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
                                        "Monday",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(93, 159, 196, 1),
                                          fontSize: 50,
                                          fontWeight: FontWeight.w500,
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
                                const ToDo(
                                  day: "Tuesday",
                                ),
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
                                        "Tuesday",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(93, 159, 196, 1),
                                          fontSize: 50,
                                          fontWeight: FontWeight.w500,
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
                                const ToDo(
                                  day: "Wednesday",
                                ),
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
                                        "Wednesday",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(93, 159, 196, 1),
                                          fontSize: 50,
                                          fontWeight: FontWeight.w500,
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
                                const ToDo(
                                  day: "Thursday",
                                ),
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
                                        "Thursday",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(93, 159, 196, 1),
                                          fontSize: 50,
                                          fontWeight: FontWeight.w500,
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
                                const ToDo(
                                  day: "Friday",
                                ),
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
                                        "Friday",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(93, 159, 196, 1),
                                          fontSize: 50,
                                          fontWeight: FontWeight.w500,
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
                                const ToDo(
                                  day: "Saturday",
                                ),
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
                                        "Saturday",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(93, 159, 196, 1),
                                          fontSize: 50,
                                          fontWeight: FontWeight.w500,
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
                                const ToDo(
                                  day: "Sunday",
                                ),
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
                                        "Sunday",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(93, 159, 196, 1),
                                          fontSize: 50,
                                          fontWeight: FontWeight.w500,
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
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Get.to(
                  const Calendar(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
                child: Container(
                  width: 100,
                  child: Center(
                    child: Text(
                      'See Week',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
