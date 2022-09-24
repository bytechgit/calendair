import 'dart:async';
import 'package:calendair/loginRegister.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 1), () {
      Get.to(
        const LoginRegister(),
        transition: Transition.circularReveal,
        duration: const Duration(milliseconds: 800),
      );
    });
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
      ),
    );
  }
}
