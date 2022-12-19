// ignore_for_file: use_build_context_synchronously
import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/student/navigation.dart';
import 'package:calendair/student/student_dashboard.dart';
import 'package:calendair/student_teacher/choose_user_type.dart';
import 'package:calendair/teacher/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseController = context.read<FirebaseController>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromRGBO(247, 247, 247, 1),
        child: Stack(children: [
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/backgroundTop.png'),
            ),
          ),
          IgnorePointer(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/images/backgroundBottom.png'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50.w,
                  child: Image.asset('assets/images/logo.png'),
                ),
                const Text(
                  "Register",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 15),
                  child: SizedBox(
                    width: 70.w,
                    height: 60,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                      onPressed: () async {
                        await firebaseController.signInwithGoogle();
                        // gc.getCourseListTeacher();
                      },
                      icon: Image.asset(
                        'assets/images/google.png',
                        width: 24,
                      ),
                      label: const Text(
                        'Sign in with Google',
                        style: TextStyle(
                            color: Color.fromRGBO(117, 117, 117, 1),
                            fontSize: 18),
                      ), // <-- Text
                    ),
                  ),
                ),
                SizedBox(
                  width: 35.w,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                        backgroundColor: const Color.fromRGBO(94, 159, 197, 1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    onPressed: () async {
                      if (firebaseController.auth.currentUser != null) {
                        final rez = await firebaseController
                            .register(firebaseController.auth.currentUser!.uid);
                        if (rez == null) {
                          //ne postoji user
                          Get.to(const ChooseUserType());
                        } else {
                          if (rez.type == 'student') {
                            Get.to(const Navigation());
                          } else {
                            Get.to(const TeacherDashboard());
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please sign in first"),
                          ),
                        );
                      }
                    },

                    child: const FittedBox(
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ), // <-- Text
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
