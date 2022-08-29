import 'dart:async';

import 'package:calendair/rate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class joinNotification extends StatefulWidget {
  String name;
  joinNotification({Key? key, required this.name}) : super(key: key);

  @override
  State<joinNotification> createState() => _joinNotificationState();
}

class _joinNotificationState extends State<joinNotification> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Get.to(
        rate(name: widget.name == "" ? "Course" : widget.name),
        transition: Transition.circularReveal,
        duration: const Duration(milliseconds: 800),
      );
    });
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromRGBO(247, 247, 247, 1),
          child: Stack(children: [
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
            ///////images
            ///
            ///
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "You have joined",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 40),
                        ),
                      ),
                    ),
                    SizedBox(
                      //  width: width * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${widget.name} Class",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: const Color.fromRGBO(93, 159, 196, 1),
                              fontWeight: FontWeight.w400,
                              fontSize: 40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Image.asset(
                        'assets/images/joinNotification.png',
                        scale: 1.9,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //   child: Container(
                    //     height: 6,
                    //     width: width * 0.7,
                    //     decoration: const BoxDecoration(
                    //         color: Color.fromRGBO(94, 159, 196, 1),
                    //         borderRadius:
                    //             BorderRadius.all(Radius.circular(13))),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 5.0),
                    //   child: SizedBox(
                    //     width: width * 0.7,
                    //     //height: 40,
                    //     child: TextField(
                    //       style: const TextStyle(
                    //           color: Color.fromRGBO(38, 64, 78, 1),
                    //           fontSize: 25),
                    //       textAlignVertical: TextAlignVertical.center,
                    //       decoration: InputDecoration(
                    //         contentPadding:
                    //             const EdgeInsets.symmetric(horizontal: 10.0),
                    //         border: OutlineInputBorder(
                    //           borderSide: BorderSide.none,
                    //           borderRadius: BorderRadius.circular(10.0),
                    //         ),
                    //         filled: true,
                    //         hintStyle: const TextStyle(
                    //             color: Color.fromRGBO(38, 64, 78, 1),
                    //             fontSize: 25),
                    //         hintText: "000-000",
                    //         fillColor: const Color.fromRGBO(94, 159, 197, 1),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //   child: SizedBox(
                    //     width: width * 0.5,
                    //     child: const Text(
                    //       "This code will be given by your teacher!",
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //           color: Color.fromRGBO(123, 123, 123, 1),
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 18),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 50,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                    //       primary: const Color.fromRGBO(94, 159, 197, 1),
                    //       elevation: 0,
                    //       shape: const CircleBorder(),
                    //     ),
                    //     onPressed: () {},

                    //     child: Icon(
                    //       Icons.arrow_forward_ios_rounded,
                    //       color: Colors.black,
                    //     ), // <-- Text
                    //   ),
                    // ),
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
