import 'package:calendair/models/course_model.dart';
import 'package:calendair/models/popup_model.dart';
import 'package:calendair/student_teacher/bottom_nav_bar.dart';
import 'package:calendair/teacher/popup_average_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class PopUpResults extends StatelessWidget {
  final CourseModel course;
  final List<PopUpModel> popups;
  const PopUpResults({super.key, required this.course, required this.popups});

  @override
  Widget build(BuildContext context) {
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
                width: 50.w,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    course.name,
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
              width: 80.w,
              child: const Divider(
                thickness: 10,
                height: 15,
                color: Color.fromRGBO(223, 223, 223, 1),
              ),
            ),
            SizedBox(
              width: 80.w,
              child: const Text(
                "Pop-Up Results",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(93, 159, 196, 1),
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...popups.map((p) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, bottom: 15),
                          child: SizedBox(
                            width: 80.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shadowColor:
                                      const Color.fromRGBO(247, 247, 247, 1),
                                  backgroundColor:
                                      const Color.fromRGBO(94, 159, 197, 1),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                              onPressed: () {
                                double a = (p.sumRate);
                                int b = p.numRate;
                                Get.to(
                                  PopUpAverageResult(rez: a / (b == 0 ? 1 : b)),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(children: [
                                    const TextSpan(
                                      text: 'See ',
                                      style: TextStyle(
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "${DateFormat("MM/dd/yy").format(p.dueDate.toDate())} ${p.title}",
                                      style: const TextStyle(
                                        color: Color.fromRGBO(75, 77, 76, 1),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' Results',
                                      style: TextStyle(
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                                ),
                              ), // <-- Text
                            ),
                          ),
                        );
                      }).toList()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
