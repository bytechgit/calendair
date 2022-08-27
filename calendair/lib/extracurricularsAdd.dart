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

class ExtracurricularsAdd extends StatefulWidget {
  const ExtracurricularsAdd({Key? key}) : super(key: key);

  @override
  State<ExtracurricularsAdd> createState() => _ExtracurricularsAddState();
}

class _ExtracurricularsAddState extends State<ExtracurricularsAdd> {
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
        selected: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: SizedBox(
                    width: width * 0.85,
                    child: const Text(
                      'Add an Extracurricular',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.85,
                  child: TextField(
                    maxLines: 4,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                        color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                      hintText: "Extracurricular Title",
                      fillColor: Color.fromRGBO(217, 217, 217, 1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                SizedBox(
                  width: width * 0.6,
                  child: const Text(
                    'How long will this activity take?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.7,
                  child: TextField(
                    maxLines: 4,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                        color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                      hintText: "00 minutes",
                      fillColor: Color.fromRGBO(217, 217, 217, 1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
