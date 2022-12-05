import 'package:calendair/student_teacher/login.dart';
import 'package:calendair/student_teacher/enter_school_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../classes/googleClassroom.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final gc = Get.find<GoogleClassroom>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromRGBO(247, 247, 247, 1),
        child: Stack(children: [
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SizedBox(
                    width: width * 0.55,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                      onPressed: () {
                        Get.to(
                          const Login(),
                          transition: Transition.circularReveal,
                          duration: const Duration(milliseconds: 800),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // <-- Text
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SizedBox(
                    width: width * 0.55,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                      onPressed: () {
                        Get.to(
                          const EnterSchoolCode(),
                          transition: Transition.circularReveal,
                          duration: const Duration(milliseconds: 800),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // <-- Text
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
