import 'dart:async';

import 'package:calendair/student/rate_class_strength.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class JoinClassNotification extends StatelessWidget {
  final String name;
  const JoinClassNotification({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: RateClassStrength(name: name == "" ? "Course" : name),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.fade,
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
                          "$name Class",
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
