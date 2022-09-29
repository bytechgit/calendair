import 'package:calendair/classes/firestore.dart';
import 'package:calendair/classes/scheduleLists.dart';
import 'package:calendair/extracurricularButton.dart';
import 'package:calendair/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'classes/googleClassroom.dart';
import 'bottomNavBar.dart';
import 'dashboard.dart';
import 'models/nbar.dart';

class BreakDay extends StatefulWidget {
  const BreakDay({Key? key}) : super(key: key);

  @override
  State<BreakDay> createState() => _BreakDayState();
}

class _BreakDayState extends State<BreakDay> {
  final gc = Get.find<GoogleClassroom>();
  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final scheduleLists = Get.find<ScheduleLists>();

  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedIndex = Firestore().firebaseUser?.breakday ?? -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back(closeOverlays: true);
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
                  const Settings(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              })
        ],
        selected: 1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: SizedBox(
                    width: width * 0.85,
                    child: const Text(
                      'Add/Change Breakday',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 217, 217, 217),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  width: width * 0.85,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Which day would you like less work? We may not be able to ensure that day will be empty',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: SizedBox(
                    width: width * 0.6,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        for (int i = 0; i < days.length; i++)
                          ExtracurricularButton(
                            text: days[i],
                            index: i,
                            selectedIndex: selectedIndex,
                            onClick: () {
                              setState(() {
                                if (selectedIndex == i) {
                                  selectedIndex = -1;
                                } else {
                                  if (!scheduleLists.breakDayIsEmpty(i)) {
                                    Get.snackbar(
                                        "Break day", "Choose another day");
                                    return;
                                  }
                                  selectedIndex = i;
                                }
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                  child: SizedBox(
                    width: width * 0.40,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                      onPressed: () {
                        Firestore().addBreakDay(selectedIndex);
                        Get.back(closeOverlays: true);
                      },

                      child: const Text(
                        'Save',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                        ),
                      ), // <-- Text
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.9,
                  child: const Text(
                    'If you dont select a break day, we’ll balance out your workload throughout the week like normal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
