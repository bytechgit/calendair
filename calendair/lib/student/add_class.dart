import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/student/join_class_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddClass extends StatelessWidget {
  const AddClass({super.key});

  @override
  Widget build(BuildContext context) {
    final codeController = TextEditingController();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: const Color.fromRGBO(247, 247, 247, 1),
          child: Stack(children: [
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Insert Class Code",
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
                    //ssheigb
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: SizedBox(
                        width: 70.w,
                        //height: 40,
                        child: TextField(
                          controller: codeController,
                          style: const TextStyle(
                              color: Color.fromRGBO(38, 64, 78, 1),
                              fontSize: 25),
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(38, 64, 78, 1),
                                fontSize: 25),
                            hintText: "000-000",
                            fillColor: const Color.fromRGBO(94, 159, 197, 1),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SizedBox(
                        width: 50.w,
                        child: const Text(
                          "This code will be given by your teacher!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(123, 123, 123, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: const CircleBorder(),
                        ),
                        onPressed: () async {
                          String name = await context
                              .read<FirebaseController>()
                              .enrolToCourse(codeController.text);

                          if (name != "" && name != "Error") {
                            // ignore: use_build_context_synchronously
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: JoinClassNotification(name: name),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          } else {
                            Get.snackbar("Error", "Class does not exist");
                          }
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                        ), // <-- Text
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
