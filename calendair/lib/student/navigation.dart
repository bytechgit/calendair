import 'package:calendair/student/dashboard.dart';
import 'package:calendair/student/student_dashboard.dart';
import 'package:calendair/student/student_settings.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sizer/sizer.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late PersistentTabController persistentTabController;
  @override
  void initState() {
    persistentTabController = PersistentTabController(initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: persistentTabController,
      navBarStyle: NavBarStyle.style1,
      navBarHeight: 9.h,
      screens: const [Dashboard(), StudentDashboard(), StudentSettings()],
      hideNavigationBarWhenKeyboardShows: true,
      backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
      decoration: const NavBarDecoration(
        colorBehindNavBar: Color.fromARGB(255, 4, 83, 242),
      ),
      items: [
        PersistentBottomNavBarItem(
          icon: Image.asset(
            'assets/images/calendar.png',
            width: 35,
          ),
          textStyle: const TextStyle(fontSize: 15),
          activeColorSecondary: const Color.fromARGB(255, 255, 255, 255),
          // title: (" Home"),
          activeColorPrimary: const Color.fromARGB(255, 255, 255, 255),
          inactiveColorPrimary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          icon: Image.asset(
            'assets/images/home.png',
            width: 35,
          ),
          //title: ("Statistics"),
          contentPadding: 0,
          textStyle: const TextStyle(fontSize: 15),
          activeColorSecondary: const Color.fromARGB(255, 255, 255, 255),
          activeColorPrimary: const Color.fromARGB(255, 255, 255, 255),
          inactiveColorPrimary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          contentPadding: 0,
          icon: Image.asset(
            'assets/images/settings.png',
            width: 35,
          ),
          //  title: ("Prfile"),
          textStyle: const TextStyle(fontSize: 15),
          activeColorSecondary: const Color.fromARGB(255, 255, 255, 255),
          activeColorPrimary: const Color.fromARGB(255, 255, 255, 255),
          inactiveColorPrimary: Colors.white,
        ),
      ],
    );
  }
}
