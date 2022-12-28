import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/controllers/nav_bar_controller.dart';
import 'package:calendair/controllers/student_state.dart';
import 'package:calendair/controllers/teacher_state.dart';
import 'package:calendair/controllers/timer.dart';
import 'package:calendair/schedule/schedule_controller.dart';
import 'package:calendair/student_teacher/login_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  }); // To turn off landscape mode
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<StudentState>(create: (_) => StudentState()),
          ChangeNotifierProvider<ScheduleController>(
              create: (_) => ScheduleController()),
          ChangeNotifierProvider<TeacherState>(create: (_) => TeacherState()),
          ChangeNotifierProvider<Time>(create: (_) => Time()),
          ChangeNotifierProvider<NavBarController>(
              create: (_) => NavBarController()),

          Provider(create: (_) => FirebaseController()),
          // ProxyProvider<UserAuthentication, ScheduleController>(
          //   update: (_, ua, __) => ScheduleController(ua),
          // ),
          // // ProxyProvider<UserAuthentication, GoogleClassroom>(
          // //   update: (_, ua, __) => GoogleClassroom(ua),
          // // ),
          // ChangeNotifierProvider<GoogleClassroom>(
          //     create: (context) =>
          //         GoogleClassroom(context.read<UserAuthentication>())),
        ],
        child: GetMaterialApp(
          title: 'Calendair',
          theme: ThemeData(
            fontFamily: 'LeagueSpartan',
            primarySwatch: Colors.blue,
          ),
          home: const LoginRegister(),
        ),
      );
    });
  }
}
