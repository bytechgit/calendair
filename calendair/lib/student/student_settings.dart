import 'package:calendair/student/account_settings.dart';
import 'package:calendair/student/notification_settings.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sizer/sizer.dart';

class StudentSettings extends StatelessWidget {
  const StudentSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
      ),
      // bottomNavigationBar: NavBar(
      //   navBarItems: [
      //     NavBarItem(
      //         image: 'calendar',
      //         onclick: () {
      //           Get.to(
      //             const Dashboard(),
      //           );
      //         }),
      //     NavBarItem(
      //         image: 'home',
      //         // widget: const studentDashboard(),
      //         onclick: () {
      //           Get.until((route) =>
      //               (route as GetPageRoute).routeName == '/StudentDashboard');
      //         }),
      //     NavBarItem(
      //         image: 'settings',
      //         onclick: () {
      //           Get.to(
      //             const StudentSettings(),
      //           );
      //         })
      //   ],
      // ),
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
                    width: 70.w,
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
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const AccountSettings(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                },
                child: Container(
                  width: 75.w,
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
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const NotificationSettings(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                },
                child: Container(
                  width: 75.w,
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
                width: 50.w,
              )
            ],
          ),
        ),
      ),
    );
  }
}
