import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/models/assignment_model.dart';
import 'package:calendair/models/course_model.dart';
import 'package:calendair/student_teacher/bottom_nav_bar.dart';
import 'package:calendair/teacher/assignment_update.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Assignments extends StatefulWidget {
  final CourseModel course;
  const Assignments({super.key, required this.course});

  @override
  State<Assignments> createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  List<AssignmentModel>? assignments;
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    context
        .read<FirebaseController>()
        .getAssigments(widget.course.courseId, widget.course.docid)
        .then((value) {
      setState(() {
        assignments = value;
      });
    });
    super.initState();
  }

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
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
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
                  "Assignments",
                  style: TextStyle(
                    color: Color.fromRGBO(93, 159, 196, 1),
                    fontSize: 50,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              if (assignments != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...assignments!.map(
                          (assignment) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 80,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(243, 162, 162, 1),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 55.w,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            child: Text(
                                              assignment.title,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "${assignment.duration} Minutes",
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    143, 146, 145, 1),
                                                fontSize: 30,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    IconButton(
                                      iconSize: 55,
                                      onPressed: () {
                                        Get.to(
                                          AssignmentUpdate(
                                              update: update,
                                              assignmet: assignment,
                                              course: widget.course),
                                          duration:
                                              const Duration(milliseconds: 800),
                                        );
                                      },
                                      icon: const Icon(Icons.settings),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ],
                    ),
                  ),
                ),
              if (assignments == null) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
