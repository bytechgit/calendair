import 'package:calendair/Classes/firestore.dart';
import 'package:calendair/models/CustomCourse.dart';
import 'package:calendair/popUpsConfidenceMeter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'Classes/googleClassroom.dart';
import 'bottomNavBar.dart';
import 'models/nbar.dart';

class PopUpsAdd extends StatefulWidget {
  CustomCourse course;
  PopUpsAdd({Key? key, required this.course}) : super(key: key);

  @override
  State<PopUpsAdd> createState() => _PopUpsAddState();
}

class _PopUpsAddState extends State<PopUpsAdd> {
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final gc = Get.find<GoogleClassroom>();
  DateTime date = DateTime.now();
  //final titleController=TextEditingController();
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
              onclick: () {
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/TeacherDashboard');
              }),
        ],
        selected: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: width * 0.5,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.course.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
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
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Pop-Up Title',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 20),
              child: SizedBox(
                width: width * 0.7,
                //height: 40,
                child: TextField(
                  controller: titleController,
                  style: const TextStyle(
                      color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    hintStyle: const TextStyle(
                        color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                    hintText: "Please Enter",
                    fillColor: const Color.fromRGBO(94, 159, 197, 1),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width * 0.85,
              child: const Text(
                'Due Date/ Date Pop-Up will be Removed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 20),
              child: InkWell(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime.now().add(Duration(days: 600)),
                      theme: const DatePickerTheme(
                          headerColor: Color.fromARGB(255, 176, 176, 176),
                          backgroundColor: Color.fromRGBO(94, 159, 197, 1),
                          itemStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16)),
                      onChanged: (date) {}, onConfirm: (d) {
                    setState(() {
                      date = d;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  width: width * 0.7,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromRGBO(94, 159, 197, 1),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat("MM/dd/yy").format(date),
                      style: const TextStyle(
                          color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width * 0.8,
              child: const Text(
                'Pop-Up Attachment',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 5),
              child: SizedBox(
                width: width * 0.70,
                height: 48,
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
                      PopUpsConfidenceMeter(
                        course: widget.course,
                      ),
                      transition: Transition.circularReveal,
                      duration: const Duration(milliseconds: 800),
                    );
                  },

                  child: const Text(
                    'Confidence Meter',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(38, 64, 78, 1),
                        fontSize: 25,
                        fontWeight: FontWeight.w400),
                  ), // <-- Text
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: width * 0.60,
                height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                      primary: const Color.fromRGBO(94, 159, 197, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  onPressed: () {
                    Firestore().addPopUp(
                        classId: widget.course.docid,
                        date: date,
                        title: titleController.text,
                        cm: gc.confidence);
                    Get.back();
                  },

                  child: const Text(
                    'Send',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // <-- Text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
