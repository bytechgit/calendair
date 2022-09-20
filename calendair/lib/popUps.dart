import 'package:calendair/classes/firestore.dart';
import 'package:calendair/models/CustomCourse.dart';
import 'package:calendair/models/PopUpModel.dart';
import 'package:calendair/popUpsAdd.dart';
import 'package:calendair/popUpsResults.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'classes/googleClassroom.dart';
import 'bottomNavBar.dart';
import 'models/nbar.dart';

class PopUps extends StatefulWidget {
  final CustomCourse course;
  const PopUps({Key? key, required this.course}) : super(key: key);

  @override
  State<PopUps> createState() => _PopUpsState();
}

class _PopUpsState extends State<PopUps> {
  final gc = Get.find<GoogleClassroom>();
  List<QueryDocumentSnapshot<Object?>> popupsLis = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              slika: 'home',
              onclick: () {
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/TeacherDashboard');
              }),
        ],
        selected: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: 80.w,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.course.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 80.w,
              child: const Divider(
                thickness: 10,
                height: 15,
                color: Color.fromRGBO(223, 223, 223, 1),
              ),
            ),
            const FittedBox(
              child: Text(
                "Pop-Ups",
                style: TextStyle(
                  color: Color.fromRGBO(93, 159, 196, 1),
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: Firestore().getTeacherPopUps(widget.course.docid),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      popupsLis = snapshot.data!.docs;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ...snapshot.data!.docs.map((d) {
                              final pu = PopUpModel.fromMap(
                                d.data() as Map<String, dynamic>,
                              );
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/images/triangle.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 55.w,
                                        child: Text(
                                          "${DateFormat("MM/dd/yy").format(pu.dueDate.toDate())} ${pu.title}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, bottom: 20, left: 10),
                  child: SizedBox(
                    width: 40.w,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      onPressed: () {
                        Get.to(
                          PopUpsResults(course: widget.course, list: popupsLis),
                          transition: Transition.circularReveal,
                          duration: const Duration(milliseconds: 800),
                        );
                      },
                      child: const Text(
                        'Pop-Up Results',
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
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, bottom: 20, right: 10),
                  child: SizedBox(
                    width: 40.w,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      onPressed: () {
                        Get.to(
                          PopUpsAdd(course: widget.course),
                          transition: Transition.circularReveal,
                          duration: const Duration(milliseconds: 800),
                        );
                      },
                      child: const Text(
                        'Add   Pop-Up',
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
