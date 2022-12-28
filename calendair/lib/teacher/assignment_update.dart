import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/models/assignment_model.dart';
import 'package:calendair/models/course_model.dart';
import 'package:calendair/student_teacher/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AssignmentUpdate extends StatelessWidget {
  final CourseModel course;
  final AssignmentModel assignmet;
  final VoidCallback update;
  const AssignmentUpdate(
      {super.key,
      required this.course,
      required this.assignmet,
      required this.update});

  @override
  Widget build(BuildContext context) {
    final minscontroller = TextEditingController();
    final noteController = TextEditingController();
    final firebaseController = context.read<FirebaseController>();
    minscontroller.text = assignmet.duration.toString();
    noteController.text = assignmet.note ?? '';
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                      course.className,
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
              FittedBox(
                child: Text(
                  assignmet.title,
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
                  width: 70.w,
                  //height: 40,
                  child: TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: true),
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
                  width: 70.w,
                  //height: 40,
                  child: TextField(
                    controller: noteController,
                    // maxLines: 3,
                    // minLines: 1,
                    // keyboardType: TextInputType.multiline,
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
                  width: 60.w,
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
                      if (int.tryParse(minscontroller.text) == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter valid duration"),
                          ),
                        );
                        return;
                      }
                      assignmet.note = noteController.text;
                      assignmet.duration = int.parse(minscontroller.text);
                      update();
                      firebaseController.updateAssignment(
                          assignment: assignmet, course: course);
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
      ),
    );
  }
}
