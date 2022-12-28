import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/controllers/teacher_state.dart';
import 'package:calendair/models/course_model.dart';
import 'package:calendair/student_teacher/bottom_nav_bar.dart';
import 'package:calendair/teacher/add_popup.dart';
import 'package:calendair/teacher/popup_results.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class PopUps extends StatefulWidget {
  final CourseModel course;
  const PopUps({super.key, required this.course});

  @override
  State<PopUps> createState() => _PopUpsState();
}

class _PopUpsState extends State<PopUps> {
  late FirebaseController firebaseController;
  @override
  void initState() {
    firebaseController = context.read<FirebaseController>();
    final state = context.read<TeacherState>();
    if (!state.popupsExist(widget.course.docId)) {
      firebaseController.getTeacherPopUps(widget.course.docId).then((value) {
        state.addPopUps(value, widget.course.docId);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeacherState>();
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
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: 80.w,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.course.className,
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
                "Pop-Ups",
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
            if (state.popupsExist(widget.course.docId))
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...state.popups[widget.course.docId]!.map((pu) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/triangle.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              SizedBox(
                                width: 55.w,
                                child: Text(
                                  "${DateFormat("MM/dd/yy").format(pu.dueDate.toDate())} ${pu.title}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList()
                  ],
                ),
              )),
            if (!state.popupsExist(widget.course.docId))
              const Expanded(child: Center(child: CircularProgressIndicator())),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, bottom: 20, left: 10),
                  child: SizedBox(
                    width: 40.w,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      onPressed: () {
                        Get.to(
                          PopUpResults(
                            popups: state.popups[widget.course.docId] ?? [],
                            course: widget.course,
                          ),
                        );
                      },
                      child: const Text(
                        'Pop-Up Results',
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
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, bottom: 20, right: 10),
                  child: SizedBox(
                    width: 40.w,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      onPressed: () {
                        Get.to(
                          AddPopUp(course: widget.course),
                        );
                      },
                      child: const Text(
                        'Add   Pop-Up',
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
      ),
    );
  }
}
