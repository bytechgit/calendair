import 'package:calendair/classes/Authentication.dart';
import 'package:calendair/registerWhatUser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'classes/googleClassroom.dart';

class RegisterGoogle extends StatelessWidget {
  const RegisterGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final gc = Get.find<GoogleClassroom>();
    final u = UserAuthentication();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: const Color.fromRGBO(247, 247, 247, 1),
          child: Stack(children: [
            Align(
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
                    "Register",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 15),
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
                          await u.signInwithGoogle();
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
                    width: width * 0.35,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                      onPressed: () {
                        if (gc.ua.googleSignIn.currentUser != null) {
                          Get.to(
                            const RegisterWhatUser(),
                            transition: Transition.circularReveal,
                            duration: const Duration(milliseconds: 800),
                          );
                        } else {
                          Get.snackbar('Sign in', 'Please sign in first');
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
      ),
    );
  }
}
