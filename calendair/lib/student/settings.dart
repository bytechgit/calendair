import 'package:calendair/student/account_settings.dart';
import 'package:calendair/student/notification_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../classes/googleClassroom.dart';
import '../student_teacher/bottom_nav_bar.dart';
import 'dashboard.dart';
import '../models/nbar.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final gc = Get.find<GoogleClassroom>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
            //inspect(gc.courses);
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        items: [
          NBar(
              slika: 'calendar',
              onclick: () {
                Get.off(
                  const Dashboard(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              }),
          NBar(
              slika: 'home',
              onclick: () {
                Get.until(
                    (route) => route.settings.name == '/StudentDashboard');
              }),
          NBar(
              slika: 'settings',
              onclick: () {
                Get.off(
                  const Settings(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              })
        ],
        selected: 2,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 40),
                  child: SizedBox(
                    width: width * 0.7,
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(
                    const AccountSettings(),
                    transition: Transition.circularReveal,
                    duration: const Duration(milliseconds: 800),
                  );
                },
                child: Container(
                  width: width * 0.75,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(93, 159, 196, 1),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 40, 10),
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Account Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(38, 64, 78, 1),
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Get.to(
                    const NotificationSettings(),
                    transition: Transition.circularReveal,
                    duration: const Duration(milliseconds: 800),
                  );
                },
                child: Container(
                  width: width * 0.75,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(93, 159, 196, 1),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 40, 10),
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Notifications',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(38, 64, 78, 1),
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              Image.asset(
                'assets/images/logoSettings.png',
                width: width * 0.5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
