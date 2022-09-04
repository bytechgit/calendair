import 'package:calendair/Classes/navBar.dart';
import 'package:calendair/classes/ExtButton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Classes/googleClassroom.dart';
import 'loginRegister.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  Get.put(GoogleClassroom());
  Get.put(ExtButton());
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
      home: const LoginRegister(),
    );
  }
}
