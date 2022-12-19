import 'package:calendair/classes/google_classroom.dart';
import 'package:calendair/teacher/generating_class_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../student_teacher/bottom_nav_bar.dart';
import '../models/nbar.dart';
import 'package:form_field_validator/form_field_validator.dart';

class MakeClass extends StatefulWidget {
  const MakeClass({Key? key}) : super(key: key);
  @override
  State<MakeClass> createState() => _MakeClassState();
}

class _MakeClassState extends State<MakeClass> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final periodController = TextEditingController();
  final nameController = TextEditingController();
  late final GoogleClassroom googleClassroom;

  @override
  void initState() {
    googleClassroom = context.read<GoogleClassroom>();
    super.initState();
  }

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
      body: SafeArea(
        child: Center(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70.w,
                  child: const Text(
                    'What would you like to name your class?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                  child: SizedBox(
                    width: 70.w,
                    height: 70,
                    child: TextFormField(
                      controller: nameController,
                      maxLines: 1,
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
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                        hintText: "Please Enter",
                        fillColor: const Color.fromRGBO(94, 159, 197, 1),
                        errorStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      validator: MultiValidator(
                        [
                          RequiredValidator(errorText: "Enter class name"),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80.w,
                  child: const FittedBox(
                    child: Text(
                      'What period is this class in?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                  child: SizedBox(
                    width: 70.w,
                    height: 50,
                    child: TextFormField(
                      controller: periodController,
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
                        hintText: "00",
                        fillColor: const Color.fromRGBO(94, 159, 197, 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 70.w,
                  child: const Text(
                    'Choose the Google Classroom to sync to.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                  child: SizedBox(
                    width: 70.w,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                      onPressed: () async {
                        Get.defaultDialog(
                            title: "Select google classroom",
                            titleStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                            content: FutureBuilder<List<classroom.Course>>(
                                future: googleClassroom.getCourseList(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return SizedBox(
                                      height: 50.h,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            ////printskrin bluetooth
                                            const SizedBox(
                                              width: double.infinity,
                                            ),
                                            ...(snapshot.data!).map((e) =>
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 40,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            child: FittedBox(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              child: Text(
                                                                e.name ??
                                                                    "no name",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: IconButton(
                                                              iconSize: 30,
                                                              onPressed: () {
                                                                googleClassroom
                                                                    .addClass(
                                                                        e);
                                                                Get.off(
                                                                  GeneratingClassCode(
                                                                      futureCode: Future.delayed(
                                                                          const Duration(
                                                                              seconds: 1),
                                                                          () {
                                                                    return e.enrollmentCode ??
                                                                        "";
                                                                  })),
                                                                  transition:
                                                                      Transition
                                                                          .circularReveal,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          800),
                                                                );
                                                              },
                                                              icon: const Icon(Icons
                                                                  .arrow_right)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }));
                      },

                      child: const Text('Select',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(38, 64, 78, 1),
                              fontSize: 25)), // <-- Text
                    ),
                  ),
                ),
                InkWell(
                  onTap: (() async {
                    if (formkey.currentState?.validate() == true) {
                      Get.to(
                        GeneratingClassCode(
                            futureCode: googleClassroom.createCourse(
                                nameController.text, periodController.text)),
                        transition: Transition.circularReveal,
                        duration: const Duration(milliseconds: 800),
                      );
                    }
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
        ),
      ),
    );
  }
}
