import 'package:calendair/classes/fcmNotification.dart';
import 'package:calendair/classes/navBar.dart';
import 'package:calendair/classes/scheduleController.dart';
import 'package:calendair/classes/scheduleLists.dart';
import 'package:calendair/classes/timerAssignment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'classes/googleClassroom.dart';
import 'classes/background.dart';
import 'student_teacher/login_register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // ignore: unused_local_variable
  FCMNotification fcm = FCMNotification();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  // await Background().initializeService();
  Get.put(ScheduleLists());
  Get.put(GoogleClassroom());
  Get.put(TimerAssignment());
  Get.put(ScheduleController());
  Get.put(NavBar());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  }); // To turn off landscape mode
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'LeagueSpartan',
          primarySwatch: Colors.blue,
        ),
        home: const LoginRegister(),
      );
    });
  }
}
