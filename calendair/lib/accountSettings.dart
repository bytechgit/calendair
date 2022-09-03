import 'package:calendair/models/nbar.dart';
import 'package:calendair/settings.dart';
import 'package:calendair/studentDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottomNavBar.dart';
import 'calendar.dart';
import 'dashboard.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
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
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        items: [
          NBar(
              slika: 'calendar',
              onclick: () {
                Get.off(
                  dashboard(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              }),
          NBar(
              slika: 'home',
              onclick: () {
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/studentDashboard');
              }),
          NBar(
              slika: 'settings',
              onclick: () {
                Get.off(
                  Settings(),
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
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: width * 0.8,
                child: const FittedBox(
                  child: Text(
                    'Account Settings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            SizedBox(
              width: width * 0.13,
              child: const FittedBox(
                child: const Text(
                  'Icon',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(93, 159, 196, 1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                    child: SizedBox(
                  width: 140,
                  child: Text(
                    'Insert Photo',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: width * 0.13,
                child: const FittedBox(
                  child: Text(
                    'Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 30),
              child: SizedBox(
                width: width * 0.7,
                //height: 40,
                child: TextField(
                  maxLines: 3,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                      color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    hintStyle: const TextStyle(
                        color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                    hintText: "Please Enter",
                    fillColor: const Color.fromRGBO(94, 159, 197, 1),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: SizedBox(
                width: width * 0.6,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                      primary: const Color.fromRGBO(94, 159, 197, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  onPressed: () {
                    Get.back();
                  },

                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Update',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ), // <-- Text
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
