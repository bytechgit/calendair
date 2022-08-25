import 'package:calendair/dashboardPeriod.dart';
import 'package:calendair/makeClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  changeTabIndex(int i) {}
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(93, 159, 196, 1),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Color.fromRGBO(93, 159, 196, 1),
        child: IconButton(
          icon: Image.asset('assets/images/home.png'),
          onPressed: (() {}),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: width * 0.5,
                  child: const FittedBox(
                    child: Text(
                      'Classes',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(223, 223, 223, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(children: [
                            for (int i = 0; i < 10; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: InkWell(
                                  onTap: (() {
                                    Get.to(
                                      const DashboardPeriod(),
                                      transition: Transition.circularReveal,
                                      duration:
                                          const Duration(milliseconds: 800),
                                    );
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(94, 159, 197, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    height: 65,
                                    child: const Center(
                                      child: FittedBox(
                                        child: Text(
                                          'Period 1: AP Biology',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(38, 65, 78, 1),
                                            fontSize: 36,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 100,
                              ),
                            ),
                          ]),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: width * 0.40,
                              height: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shadowColor:
                                        const Color.fromRGBO(247, 247, 247, 1),
                                    primary:
                                        const Color.fromRGBO(94, 159, 197, 1),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                onPressed: () {
                                  Get.to(
                                    const MakeClass(),
                                    transition: Transition.circularReveal,
                                    duration: const Duration(milliseconds: 800),
                                  );
                                },

                                child: const Text(
                                  'Make a class',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ), // <-- Text
                              ),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(-15, 20),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: SizedBox(
                                width: width * 0.4,
                                child: Image.asset(
                                    'assets/images/teacherDashboard.png')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
