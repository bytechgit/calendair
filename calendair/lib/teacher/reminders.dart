import 'dart:developer';
import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/controllers/teacher_state.dart';
import 'package:calendair/models/course_model.dart';
import 'package:calendair/student_teacher/bottom_nav_bar.dart';
import 'package:calendair/teacher/add_update_reminder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class Reminders extends StatefulWidget {
  final CourseModel course;
  const Reminders({super.key, required this.course});

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  late FirebaseController firebaseController;
  @override
  void initState() {
    firebaseController = context.read<FirebaseController>();
    final state = context.read<TeacherState>();
    if (!state.reminderExist(widget.course.docid)) {
      firebaseController.getTeacherRemider(widget.course.docid).then((value) {
        state.addReminders(value, widget.course.docid);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeacherState>();
    inspect(state);
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
      bottomNavigationBar: NavBar(
        navBarItems: [
          NavBarItem(
              image: 'home',
              onclick: () {
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/TeacherDashboard');
              }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              width: 80.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.course.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 80.w,
            child: const Divider(
              thickness: 10,
              height: 15,
              color: Color.fromRGBO(223, 223, 223, 1),
            ),
          ),
          const FittedBox(
            child: Text(
              "Reminders",
              style: TextStyle(
                color: Color.fromRGBO(93, 159, 196, 1),
                fontSize: 50,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (state.reminderExist(widget.course.docid))
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  ...state.reminders[widget.course.docid]!.map((r) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(243, 162, 162, 1),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 55.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      r.title,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Date: ${DateFormat("MM/dd/yy").format(r.date.toDate())}",
                                      style: const TextStyle(
                                        color: Color.fromRGBO(143, 146, 145, 1),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            IconButton(
                              iconSize: 40,
                              onPressed: () {
                                Get.to(
                                  AddUpdateReminder(
                                    course: widget.course,
                                    reminder: r,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.settings),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList()
                ],
              ),
            )),
          if (!state.reminderExist(widget.course.docid))
            const Expanded(child: Center(child: CircularProgressIndicator())),
          Row(
            children: [
              Expanded(child: Container()),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, bottom: 20, right: 10),
                child: SizedBox(
                  width: 50.w,
                  height: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                        backgroundColor: const Color.fromRGBO(94, 159, 197, 1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    onPressed: () {
                      Get.to(
                        AddUpdateReminder(
                          course: widget.course,
                        ),
                      );
                    },
                    child: const Text(
                      'Add Class Reminder',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // <-- Text
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
