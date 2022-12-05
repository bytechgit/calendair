import 'package:calendair/classes/firestore.dart';
import 'package:calendair/student/extracurricularButton.dart';
import 'package:calendair/models/ExtracurricularsModel.dart';
import 'package:calendair/student/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../classes/googleClassroom.dart';
import '../student_teacher/bottom_nav_bar.dart';
import 'dashboard.dart';
import '../models/nbar.dart';

class ExtracurricularsAdd extends StatefulWidget {
  final ExtracurricularsModel? ext;
  const ExtracurricularsAdd({Key? key, this.ext}) : super(key: key);

  @override
  State<ExtracurricularsAdd> createState() => _ExtracurricularsAddState();
}

class _ExtracurricularsAddState extends State<ExtracurricularsAdd> {
  final titleController = TextEditingController();
  final minutesController = TextEditingController();
  int selectedIndex = -1;
  @override
  void initState() {
    if (widget.ext != null) {
      titleController.text = widget.ext!.title;
      minutesController.text = widget.ext!.time.toString();
      setState(() {
        selectedIndex = widget.ext!.dayIndex;
      });
    }
    super.initState();
  }

  final gc = Get.find<GoogleClassroom>();
  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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
            Get.back(closeOverlays: true);
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
                  const Settings(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              })
        ],
        selected: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: SizedBox(
                    width: width * 0.85,
                    child: const Text(
                      'Add an Extracurricular',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.85,
                  child: TextField(
                    controller: titleController,
                    maxLines: 4,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                        color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                      hintText: "Extracurricular Title",
                      fillColor: const Color.fromRGBO(217, 217, 217, 1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: width * 0.6,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        for (int i = 0; i < days.length; i++)
                          ExtracurricularButton(
                            text: days[i],
                            index: i,
                            selectedIndex: selectedIndex,
                            onClick: () {
                              setState(() {
                                selectedIndex = i;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.6,
                  child: const Text(
                    'How long will this activity take?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.7,
                  child: TextField(
                    controller: minutesController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                      hintText: "00 minutes",
                      fillColor: const Color.fromRGBO(217, 217, 217, 1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SizedBox(
                    width: width * 0.40,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                      onPressed: () {
                        if (titleController.text.isEmpty) {
                          Get.snackbar("A required field is mising",
                              'Please enter title');
                          return;
                        }
                        if (minutesController.text.isEmpty ||
                            int.tryParse(minutesController.text) == null) {
                          Get.snackbar("A required field is mising",
                              'Please enter time');
                          return;
                        }
                        if (Firestore().firebaseUser?.breakday ==
                            selectedIndex) {
                          Get.snackbar("Breakday", 'Please select another day');
                          return;
                        }
                        if (widget.ext != null) {
                          if (widget.ext!.dayIndex != selectedIndex) {
                            widget.ext!.index = 1000;
                          }
                          final prevIndex = widget.ext!.dayIndex;
                          final prevTime = widget.ext!.time;
                          widget.ext!.dayIndex = selectedIndex;
                          widget.ext!.time = int.parse(minutesController.text);
                          widget.ext!.title = titleController.text;
                          Firestore().updateExtracurriculars(
                              widget.ext!, prevIndex, prevTime);
                        } else {
                          Firestore().addExtracurriculars(
                              int.parse(minutesController.text),
                              titleController.text,
                              selectedIndex);
                        }
                        Get.back(closeOverlays: true);
                      },
                      child: const Text(
                        'Save',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                        ),
                      ), // <-- Text
                    ),
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
