import 'dart:developer';

import 'package:calendair/extracurricularButton.dart';
import 'package:calendair/rate.dart';
import 'package:calendair/settings.dart';
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

class BreakDay extends StatefulWidget {
  const BreakDay({Key? key}) : super(key: key);

  @override
  State<BreakDay> createState() => _BreakDayState();
}

class _BreakDayState extends State<BreakDay> {
  final gc = Get.find<GoogleClassroom>();
  final days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];
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
          },
        ),
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
            widget: const Settings(),
          )
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
                          children: [
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Mon", f: () {})),
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Tue", f: () {})),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Wed", f: () {})),
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Thu", f: () {})),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Fri", f: () {})),
                            Expanded(
                                child: ExtracurricularButton(
                                    text: "Sat", f: () {})),
                          ],
                        ),
                        SizedBox(
                            width: width * 0.3,
                            child:
                                ExtracurricularButton(text: "Sun", f: () {})),
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
                        Get.back();
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
