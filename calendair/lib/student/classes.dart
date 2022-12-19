import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/controllers/student_state.dart';
import 'package:calendair/student/add_class.dart';
import 'package:calendair/student/rate_class_strength.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Classes extends StatefulWidget {
  const Classes({super.key});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  late FirebaseController firebaseController;
  @override
  void initState() {
    firebaseController = context.read<FirebaseController>();
    final state = context.read<StudentState>();
    if (state.courses == null) {
      firebaseController.getStudentCourses().then((value) {
        state.addCourses(value);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final studentState = context.watch<StudentState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      // bottomNavigationBar: NavBar(
      //   navBarItems: [
      //     NavBarItem(
      //         image: 'calendar',
      //         onclick: () {
      //           Get.off(
      //             const Dashboard(),
      //           );
      //         }),
      //     NavBarItem(
      //         image: 'home',
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
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: 50.w,
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
                        if (studentState.courses != null)
                          SingleChildScrollView(
                            child: Column(children: [
                              ...studentState.courses!.map((c) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: InkWell(
                                    onTap: (() {}),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(94, 159, 197, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      height: 65,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 50.w,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  c.name,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        38, 65, 78, 1),
                                                    fontSize: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Image.asset(
                                                'assets/images/settings.png',
                                                width: 30,
                                              ),
                                            ),
                                            onTap: () {
                                              PersistentNavBarNavigator
                                                  .pushNewScreen(
                                                context,
                                                screen: RateClassStrength(
                                                  name: c.name,
                                                  //back3: false,
                                                ),
                                                withNavBar: false,
                                                pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .fade,
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                ),
                              ),
                            ]),
                          ),
                        if (studentState.courses == null)
                          const Center(child: CircularProgressIndicator()),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: 40.w,
                              height: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shadowColor:
                                        const Color.fromRGBO(247, 247, 247, 1),
                                    backgroundColor:
                                        const Color.fromRGBO(94, 159, 197, 1),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                onPressed: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const AddClass(),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.fade,
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
                          offset: const Offset(-15, 20),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: SizedBox(
                                width: 40.w,
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
