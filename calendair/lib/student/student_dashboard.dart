import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/models/popup_model.dart';
import 'package:calendair/schedule/schedule_controller.dart';
import 'package:calendair/student/add_edit_breakday.dart';
import 'package:calendair/student/confidence_merer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'classes.dart';
import 'extracurriculars.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool open = true;
  late final FirebaseController firebaseController;
  late final ScheduleController scheduleController;
  List<PopUpModel> popups = [];
  @override
  void initState() {
    firebaseController = context.read<FirebaseController>();
    scheduleController = context.read<ScheduleController>();
    firebaseController.getExtracurriculars().then((value) {
      scheduleController.addExtracurriculars(value);
      scheduleController.listen(firebaseController.currentUser!.uid);
    });

    firebaseController.getStudentPopUps().listen((event) {
      setState(() {
        popups =
            event.docs.map((e) => PopUpModel.fromMap(e.data(), e.id)).toList();
        open = true;
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    scheduleController.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SizedBox(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SizedBox(
                        width: 70.w,
                        child: const FittedBox(
                          child: Text(
                            'Dashboard',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        width: 70.w,
                        height: 80,
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
                              screen: const Classes(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          },
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Classes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ), // <-- Text
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 70.w,
                        height: 80,
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
                              screen: const Extracurriculars(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          },
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Extracurriculars',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ), // <-- Text
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 70.w,
                        height: 80,
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
                              screen: const AddEditBreakday(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          },
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Breakday',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ), // <-- Text
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (open)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 90.w,
                    height: 75.h,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(26, 71, 97, 0.9),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Container()),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      open = !open;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          const FittedBox(
                            child: Text(
                              'Pop-Ups',
                              style: TextStyle(
                                  fontSize: 50,
                                  color: Color.fromRGBO(171, 223, 252, 1),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ...popups.map((e) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(
                                          ConfidenceMeter(
                                              id: e.docId,
                                              question:
                                                  "${DateFormat("MM/dd/yy").format(e.dueDate.toDate())} ${e.title}",
                                              message: e.question),
                                          transition: Transition.circularReveal,
                                          duration:
                                              const Duration(milliseconds: 800),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: SizedBox(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  'assets/images/triangle.png',
                                                  width: 15,
                                                  height: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 65.w,
                                                child: Text(
                                                  "${DateFormat("MM/dd/yy").format(e.dueDate.toDate())} ${e.title}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ), // ],
        ),
      ),
    );
  }
}
