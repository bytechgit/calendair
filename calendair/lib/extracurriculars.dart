import 'package:calendair/extracurricularsAdd.dart';
import 'package:calendair/models/ExtracurricularsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'classes/firestore.dart';
import 'classes/googleClassroom.dart';
import 'bottomNavBar.dart';
import 'dashboard.dart';
import 'models/nbar.dart';
import 'settings.dart' as s;

class Extracurriculars extends StatefulWidget {
  const Extracurriculars({Key? key}) : super(key: key);

  @override
  State<Extracurriculars> createState() => _ExtracurricularsState();
}

class _ExtracurricularsState extends State<Extracurriculars> {
  final gc = Get.find<GoogleClassroom>();
  @override
  Widget build(BuildContext context) {
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
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/StudentDashboard');
              }),
          NBar(
              slika: 'settings',
              onclick: () {
                Get.off(
                  const s.Settings(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              })
        ],
        selected: 1,
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
                child: StreamBuilder(
                    stream: Firestore().getExtracurriculars(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              ...snapshot.data!.docs.map((e) {
                                final ex = ExtracurricularsModel.fromMap(
                                    e.data() as Map<String, dynamic>, e.id);
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(217, 217, 217, 1),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
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
                                          shadowColor: const Color.fromRGBO(
                                              247, 247, 247, 1),
                                          backgroundColor: const Color.fromRGBO(
                                              94, 159, 197, 1),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.to(
                                            ExtracurricularsAdd(ext: ex),
                                            transition:
                                                Transition.circularReveal,
                                            duration: const Duration(
                                                milliseconds: 800),
                                          );
                                        },

                                        child: const Text(
                                          'Edit',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 26,
                                          ),
                                        ), // <-- Text
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
                                          Firestore()
                                              .deleteExtracurriculars(ex);
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
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
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
                      Get.to(
                        const ExtracurricularsAdd(),
                        transition: Transition.circularReveal,
                        duration: const Duration(milliseconds: 800),
                      );
                    },

                    child: const Text(
                      'Add Programs/Extracurriculars',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                      ),
                    ), // <-- Text
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
