import 'package:calendair/classes/authentication.dart';
import 'package:calendair/classes/schedule_controller.dart';
import 'package:calendair/student/student_dashboard.dart';
import 'package:calendair/teacher/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userAuthentication = context.read<UserAuthentication>();
    final scheduleController = context.read<ScheduleController>();
    final width = MediaQuery.of(context).size.width;
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
                  width: width * 0.5,
                  child: Image.asset('assets/images/logo.png'),
                ),
                const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: width * 0.7,
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
                        final result =
                            await userAuthentication.signInwithGoogle();
                        if (result == null) {
                          scheduleController.streamSubscription?.cancel();
                          Get.snackbar('Register', 'Please register');
                          return;
                        }
                        if (result.type == "student") {
                          //!treba da se izmeni
                          scheduleController
                              .listen(userAuthentication.currentUser!.uid);
                          Get.to(
                            const StudentDashboard(),
                            transition: Transition.circularReveal,
                            duration: const Duration(milliseconds: 800),
                          );
                        } else if (result.type == "teacher") {
                          scheduleController.streamSubscription?.cancel();
                          Get.to(
                            const TeacherDashboard(),
                            transition: Transition.circularReveal,
                            duration: const Duration(milliseconds: 800),
                          );
                        }
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
              ],
            ),
          )
        ]),
      ),
    );
  }
}
