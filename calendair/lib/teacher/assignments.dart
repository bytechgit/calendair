import 'package:calendair/classes/authentication.dart';
import 'package:calendair/teacher/assignment_update.dart';
import 'package:calendair/models/assignment_model.dart';
import 'package:calendair/models/custom_course.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../classes/google_classroom.dart';
import '../student_teacher/bottom_nav_bar.dart';
import '../models/nbar.dart';

class Assignments extends StatefulWidget {
  final CustomCourse course;

  const Assignments({Key? key, required this.course}) : super(key: key);

  @override
  State<Assignments> createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  Future<List<MyAssignment>>? mylist;

  late final UserAuthentication userAuthentication;
  @override
  void initState() {
    mylist =
        context.read<GoogleClassroom>().getAssigmentsList(widget.course.id);
    userAuthentication = context.read<UserAuthentication>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final googleClassroom = context.watch<GoogleClassroom>();
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
            Expanded(
              child: FutureBuilder<List<MyAssignment>>(
                  future: mylist,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            for (int i = 0;
                                i < googleClassroom.assignments.length;
                                i++)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 80,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                243, 162, 162, 1),
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
                                                googleClassroom.assignments[i]
                                                        .coursework?.title ??
                                                    "no title",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            //if (gc.assignments.value[i]
                                            //         .scheduledTime !=
                                            //    null)
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "${googleClassroom.assignments[i].duration} Minutes",
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
                                                  assignmentIndex: i,
                                                  courseId:
                                                      widget.course.docid),
                                              transition:
                                                  Transition.circularReveal,
                                              duration: const Duration(
                                                  milliseconds: 800),
                                            );
                                          },
                                          icon: const Icon(Icons.settings))
                                    ],
                                  ),
                                ),
                              ) //)
                            //.toList()
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ),
      )),
    );
  }
}
