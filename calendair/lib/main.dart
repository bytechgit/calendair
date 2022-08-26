import 'package:calendair/accountSettings.dart';
import 'package:calendair/addClass.dart';
import 'package:calendair/assignments.dart';
import 'package:calendair/dashboard.dart';
import 'package:calendair/dashboardPeriod.dart';
import 'package:calendair/dayToDo.dart';
import 'package:calendair/joinNotification.dart';
import 'package:calendair/makeClass.dart';
import 'package:calendair/popUps.dart';
import 'package:calendair/rate.dart';
import 'package:calendair/reminder.dart';
import 'package:calendair/reminders.dart';
import 'package:calendair/splashScreen.dart';
import 'package:calendair/classes.dart';
import 'package:calendair/studentDashboard.dart';
import 'package:calendair/students.dart';
import 'package:calendair/teacherDashboard.dart';
import 'package:calendair/toDo.dart';
import 'package:calendair/toDoCheck.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'addClassReminder.dart';
import 'addClassReminderSend.dart';

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
      home: dashboard(),
    );
  }
}
