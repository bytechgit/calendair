import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/schedule/schedule_controller.dart';
import 'package:calendair/student/add_edit_extracurriculars.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Extracurriculars extends StatefulWidget {
  const Extracurriculars({super.key});

  @override
  State<Extracurriculars> createState() => _ExtracurricularsState();
}

class _ExtracurricularsState extends State<Extracurriculars> {
  late FirebaseController firebaseController;
  @override
  void initState() {
    firebaseController = context.read<FirebaseController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ScheduleController>();
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
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 30),
                child: SizedBox(
                  width: 70.w,
                  child: const FittedBox(
                    child: Text(
                      'Extracurriculars',
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
                flex: 8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...state.extracurriculars.map((ex) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(217, 217, 217, 1),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          height: 65,
                          child: Row(children: [
                            SizedBox(
                              width: 50.w,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Text(
                                    ex.title,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                            SizedBox(
                              width: 30.w,
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor:
                                      const Color.fromRGBO(247, 247, 247, 1),
                                  backgroundColor:
                                      const Color.fromRGBO(94, 159, 197, 1),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: AddEditExtracurriculars(
                                        extracurricular: ex),
                                    withNavBar: true,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.fade,
                                  );
                                },
                                child: const Text(
                                  'Edit',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  firebaseController.deleteExtracurriculars(ex);
                                  state.deleteExtracurricular(ex);
                                },
                                child: Image.asset(
                                  'assets/images/remove.png',
                                  height: 35,
                                ),
                              ),
                            )
                          ]),
                        );
                      }).toList()
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SizedBox(
                  width: 70.w,
                  height: 75,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                        backgroundColor: const Color.fromRGBO(94, 159, 197, 1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const AddEditExtracurriculars(),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    },
                    child: const Text(
                      'Add Programs/Extracurriculars',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
