import 'package:calendair/Classes/navBar.dart';
import 'package:calendair/accountSettings.dart';
import 'package:calendair/addClassReminder.dart';
import 'package:calendair/bottomNavBar.dart';
import 'package:calendair/confidenceMeter.dart';
import 'package:calendair/dashboard.dart';
import 'package:calendair/rate.dart';
import 'package:calendair/reminder.dart';
import 'package:calendair/reminders.dart';
import 'package:calendair/splashScreen.dart';
import 'package:calendair/studentDashboard.dart';
import 'package:calendair/toDo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'Classes/googleClassroom.dart';
import 'notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  Get.put(GoogleClassroom());
  Get.put(NavBar()); // To turn off landscape mode
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
        fontFamily: 'LeagueSpartan',
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
