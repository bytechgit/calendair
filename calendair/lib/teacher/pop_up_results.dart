import 'package:calendair/models/CustomCourse.dart';
import 'package:calendair/models/PopUpModel.dart';
import 'package:calendair/teacher/pop_up_average_results.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import '../student_teacher/bottom_nav_bar.dart';
import '../models/nbar.dart';

class PopUpResults extends StatefulWidget {
  final CustomCourse course;
  final List<QueryDocumentSnapshot<Object?>> list;
  const PopUpResults({Key? key, required this.course, required this.list})
      : super(key: key);
  @override
  State<PopUpResults> createState() => _PopUpResultsState();
}

class _PopUpResultsState extends State<PopUpResults> {
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
            SizedBox(
              width: width * 0.8,
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
                      ...widget.list.map((d) {
                        final pu = PopUpModel.fromMap(
                          d.data() as Map<String, dynamic>,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, bottom: 15),
                          child: SizedBox(
                            width: width * 0.80,
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
                                double a = (pu.sumRate);
                                int b = pu.numRate;
                                Get.to(
                                  PopUpAverageResult(rez: a / (b == 0 ? 1 : b)),
                                  transition: Transition.circularReveal,
                                  duration: const Duration(milliseconds: 800),
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
                                          "${DateFormat("MM/dd/yy").format(pu.dueDate.toDate())} ${pu.title}",
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
