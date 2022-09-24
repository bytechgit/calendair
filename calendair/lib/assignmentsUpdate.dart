import 'dart:developer';
import 'package:calendair/classes/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'classes/googleClassroom.dart';
import 'bottomNavBar.dart';
import 'models/nbar.dart';

class AssignmentsUpdate extends StatefulWidget {
  final int assignmentIndex;
  final String courseId;
  const AssignmentsUpdate(
      {Key? key, required this.assignmentIndex, required this.courseId})
      : super(key: key);

  @override
  State<AssignmentsUpdate> createState() => _AssignmentsUpdateState();
}

class _AssignmentsUpdateState extends State<AssignmentsUpdate> {
  final gc = Get.find<GoogleClassroom>();
  final minscontroller = TextEditingController();
  final noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (minscontroller.text.isEmpty) {
      minscontroller.text =
          gc.assignments.value[widget.assignmentIndex].duration.toString();
      noteController.text =
          gc.assignments.value[widget.assignmentIndex].note ?? "";
    }

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
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Period1',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 38,
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
            FittedBox(
              child: Text(
                gc.assignments.value[widget.assignmentIndex].coursework
                        ?.title ??
                    "no name",
                style: const TextStyle(
                  color: Color.fromRGBO(93, 159, 196, 1),
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              children: const [
                Text(
                  'How much time would you ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'recommend for this',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'assignment?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 35),
              child: SizedBox(
                width: width * 0.7,
                //height: 40,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: minscontroller,
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
                    hintText: "MINS",
                    fillColor: const Color.fromRGBO(94, 159, 197, 1),
                  ),
                ),
              ),
            ),
            const Text(
              'Note to the Class',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: SizedBox(
                width: width * 0.7,
                //height: 40,
                child: TextField(
                  controller: noteController,
                  maxLines: 3,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
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
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: width * 0.60,
                height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                      backgroundColor: const Color.fromRGBO(94, 159, 197, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  onPressed: () {
                    gc.assignments.value[widget.assignmentIndex].note =
                        noteController.text;
                    gc.assignments.value[widget.assignmentIndex].duration =
                        int.tryParse(minscontroller.text) ?? 0;

                    gc.assignments.refresh();
                    inspect(gc.assignments.value);
                    // gc.updateAssignment(
                    //   gc.assignments.value[widget.assignmentIndex]);
                    Firestore().insertOrUpdateAssignment(
                        gc.assignments.value[widget.assignmentIndex],
                        widget.courseId);

                    Get.back();
                  },

                  child: const Text(
                    'Update',
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
