import 'package:calendair/classes/authentication.dart';
import 'package:calendair/classes/fcm_notification.dart';
import 'package:calendair/classes/nav_bar.dart';
import 'package:calendair/classes/schedule_controller.dart';
import 'package:calendair/classes/schedule_lists.dart';
import 'package:calendair/classes/timer_assignment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'classes/google_classroom.dart';
import 'student_teacher/login_register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // ignore: unused_local_variable
  FCMNotification fcm = FCMNotification();
  Get.put(NavBar());
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
          // ChangeNotifierProvider<UserAuthentication>(
          //     create: (_) => AuthController()),
          Provider(create: (_) => UserAuthentication()),
          ProxyProvider<UserAuthentication, ScheduleController>(
            update: (_, ua, __) => ScheduleController(ua),
          ),
          // ProxyProvider<UserAuthentication, GoogleClassroom>(
          //   update: (_, ua, __) => GoogleClassroom(ua),
          // ),
          ChangeNotifierProvider<GoogleClassroom>(
              create: (context) =>
                  GoogleClassroom(context.read<UserAuthentication>())),
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
