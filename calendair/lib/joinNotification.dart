import 'dart:async';

import 'package:calendair/rate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinNotification extends StatefulWidget {
  final String name;
  const JoinNotification({Key? key, required this.name}) : super(key: key);

  @override
  State<JoinNotification> createState() => _JoinNotificationState();
}

class _JoinNotificationState extends State<JoinNotification> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Get.to(
        Rate(name: widget.name == "" ? "Course" : widget.name),
        transition: Transition.circularReveal,
        duration: const Duration(milliseconds: 800),
      );
    });
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
                              color: Color.fromRGBO(93, 159, 196, 1),
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
