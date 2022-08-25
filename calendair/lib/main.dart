import 'package:calendair/assignments.dart';
import 'package:calendair/dashboardPeriod.dart';
import 'package:calendair/makeClass.dart';
import 'package:calendair/popUps.dart';
import 'package:calendair/splashScreen.dart';
import 'package:calendair/teacherDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PopUps(),
    );
  }
}
