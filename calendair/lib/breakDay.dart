import 'package:calendair/Classes/firestore.dart';
import 'package:calendair/Classes/ExtButton.dart';
import 'package:calendair/extracurricularButton.dart';
import 'package:calendair/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Classes/googleClassroom.dart';
import 'bottomNavBar.dart';
import 'Classes/scheduleController.dart';
import 'dashboard.dart';
import 'models/nbar.dart';

class BreakDay extends StatefulWidget {
  const BreakDay({Key? key}) : super(key: key);

  @override
  State<BreakDay> createState() => _BreakDayState();
}

class _BreakDayState extends State<BreakDay> {
  final gc = Get.find<GoogleClassroom>();
  final extb = Get.find<ExtButton>();
  //final days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
  }

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
                  const dashboard(),
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
                    color: Color.fromRGBO(217, 217, 217, 1),
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Mon", index: 0, ext: false)),
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Tue", index: 1, ext: false)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Wed", index: 2, ext: false)),
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Thu", index: 3, ext: false)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Fri", index: 4, ext: false)),
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Sat", index: 5, ext: false)),
                          ],
                        ),
                        SizedBox(
                            width: width * 0.3,
                            child: const ExtracurricularButton(
                                text: "Sun", index: 6, ext: false)),
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
                          primary: const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                      onPressed: () {
                        Firestore().addBreakDay(extb.breakdayIndex.value);
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
