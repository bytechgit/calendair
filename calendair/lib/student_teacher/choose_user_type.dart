// ignore_for_file: use_build_context_synchronously

import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/models/user_model.dart';
import 'package:calendair/student/navigation.dart';
import 'package:calendair/student/student_dashboard.dart';
import 'package:calendair/teacher/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChooseUserType extends StatelessWidget {
  const ChooseUserType({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final firebaseController = context.read<FirebaseController>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromRGBO(247, 247, 247, 1),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/backgroundTop.png'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/images/backgroundBottom.png'),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        height: 6,
                        width: 70.w,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(94, 159, 196, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(13))),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "What user are you?",
                        style: TextStyle(
                            color: Color.fromRGBO(38, 64, 78, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                    InkWell(
                      onTap: (() async {
                        final rez = await firebaseController.addUser(
                            user: UserModel(
                          uid: firebaseController.auth.currentUser!.uid,
                          name: firebaseController
                                  .auth.currentUser!.displayName ??
                              "no name",
                          picture:
                              firebaseController.auth.currentUser?.photoURL ??
                                  "",
                          type: "student",
                          breakday: -1,
                        ));
                        Get.to(const Navigation());
                      }),
                      child: Container(
                        width: 70.w,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(94, 159, 197, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(13),
                          ),
                        ),
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Student",
                                style: TextStyle(
                                    color: Color.fromRGBO(38, 64, 78, 1),
                                    fontSize: 18),
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        firebaseController.addUser(
                            user: UserModel(
                                uid: firebaseController.auth.currentUser!.uid,
                                name: firebaseController
                                        .auth.currentUser!.displayName ??
                                    "no name",
                                picture: firebaseController
                                        .auth.currentUser!.photoURL ??
                                    " ",
                                type: "teacher",
                                breakday: -1));
                        //gc.getCourseListTeacher();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeacherDashboard(),
                          ),
                        );
                      },
                      child: Container(
                        width: 70.w,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(94, 159, 197, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(13),
                          ),
                        ),
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Teacher",
                                style: TextStyle(
                                    color: Color.fromRGBO(38, 64, 78, 1),
                                    fontSize: 18),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
