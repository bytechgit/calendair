import 'package:calendair/classes/authentication.dart';
import 'package:calendair/models/UserModel.dart';
import 'package:calendair/student/student_dashboard.dart';
import 'package:calendair/teacher/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChooseUserType extends StatefulWidget {
  const ChooseUserType({Key? key}) : super(key: key);

  @override
  State<ChooseUserType> createState() => _ChooseUserTypeState();
}

class _ChooseUserTypeState extends State<ChooseUserType> {
  late final UserAuthentication userAuthentication;

  @override
  void initState() {
    userAuthentication = context.read<UserAuthentication>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                        width: width * 0.7,
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
                      onTap: (() {
                        userAuthentication.addUserIfNotExist(
                            user: UserModel(
                                uid: userAuthentication.auth.currentUser!.uid,
                                name: userAuthentication
                                        .auth.currentUser!.displayName ??
                                    "no name",
                                picture: userAuthentication
                                        .auth.currentUser?.photoURL ??
                                    "",
                                type: "student",
                                breakday: -1,
                                courses: [],
                                times: {}));
                        Get.to(
                          const StudentDashboard(),
                          transition: Transition.circularReveal,
                          duration: const Duration(milliseconds: 800),
                        );
                      }),
                      child: Container(
                        width: width * 0.7,
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
                        userAuthentication.addUserIfNotExist(
                            user: UserModel(
                                uid: userAuthentication.auth.currentUser!.uid,
                                name: userAuthentication
                                        .auth.currentUser!.displayName ??
                                    "no name",
                                picture: userAuthentication
                                        .auth.currentUser!.photoURL ??
                                    "",
                                type: "teacher",
                                breakday: -1,
                                courses: [],
                                times: {}));
                        //gc.getCourseListTeacher();
                        Get.to(
                          const TeacherDashboard(),
                          transition: Transition.circularReveal,
                          duration: const Duration(milliseconds: 800),
                        );
                      },
                      child: Container(
                        width: width * 0.7,
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
