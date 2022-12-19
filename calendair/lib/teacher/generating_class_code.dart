import 'package:calendair/student_teacher/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:progress_indicators/progress_indicators.dart';

class GeneratingClassCode extends StatelessWidget {
  final Future<String>? code;
  const GeneratingClassCode({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
      ),
      bottomNavigationBar: NavBar(
        navBarItems: [
          NavBarItem(
            image: 'home',
            onclick: () {
              Get.until((route) =>
                  (route as GetPageRoute).routeName == '/TeacherDashboard');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset('assets/images/genCodeTop.png'),
              ),
            ),
            IgnorePointer(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/genCodeBottom.png'),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          const Text(
                            "Generating Class Code",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          FutureBuilder<String>(
                              future: code,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return const Text(
                                    "...",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  );
                                } else {
                                  return JumpingDotsProgressIndicator(
                                    fontSize: 18.0,
                                    dotSpacing: 0,
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 7),
                    child: Container(
                      height: 6,
                      width: 60.w,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(94, 159, 196, 1),
                          borderRadius: BorderRadius.all(Radius.circular(13))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                    child: SizedBox(
                      width: 70.w,
                      child: FutureBuilder<String>(
                          future: code,
                          builder: (context, snapshot) {
                            return TextField(
                              enabled: false,
                              style: const TextStyle(
                                  color: Color.fromRGBO(38, 64, 78, 1),
                                  fontSize: 25),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                filled: true,
                                hintStyle: const TextStyle(
                                    color: Color.fromRGBO(38, 64, 78, 1),
                                    fontSize: 25),
                                hintText: snapshot.data ?? "",
                                fillColor:
                                    const Color.fromRGBO(94, 159, 197, 1),
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: SizedBox(
                      width: 50.w,
                      child: const Text(
                        "Give this code to your students !",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(123, 123, 123, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 22),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (() {
                      Get.until((route) =>
                          (route as GetPageRoute).routeName ==
                          '/TeacherDashboard');
                    }),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(94, 159, 197, 1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
