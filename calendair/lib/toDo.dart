import 'package:calendair/settings.dart';
import 'package:calendair/toDoCheck.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottomNavBar.dart';
import 'dashboard.dart';
import 'models/nbar.dart';

class ToDo extends StatefulWidget {
  final String day;
  const ToDo({Key? key, required this.day}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
          selected: 0,
        ),
        body: SafeArea(
          child: Center(
              child: SizedBox(
            width: width * 0.8,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      width: width * 0.65,
                      child: FittedBox(
                        child: Text(
                          widget.day,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.67,
                    child: const FittedBox(
                      child: Text(
                        'August 12',
                        style: TextStyle(
                          color: Color.fromRGBO(93, 159, 196, 1),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ToDoCheck(
                            color: const Color.fromRGBO(170, 227, 155, 1),
                            number: '20',
                            name: 'WS #30 - Polynomials',
                          ),
                          ToDoCheck(
                            color: const Color.fromRGBO(241, 188, 140, 1),
                            number: '25',
                            name: 'ELA Short Response',
                          ),
                          ToDoCheck(
                            color: const Color.fromRGBO(246, 145, 145, 1),
                            number: '10',
                            name: 'Start Genetics Lab',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: width * 0.6,
                            child: const Text(
                              "\"It always seems impossible until it's done.\"",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.5,
                            child: const FittedBox(
                                child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                '-Nelson Mandela',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.58),
                                  fontSize: 18,
                                ),
                              ),
                            )),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
          )),
        ));
  }
}
