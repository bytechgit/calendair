import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/controllers/student_state.dart';
import 'package:calendair/models/extracurricular_model.dart';
import 'package:calendair/student/add_edit_breakday.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddEditExtracurriculars extends StatefulWidget {
  final ExtracurricularModel? extracurricular;
  const AddEditExtracurriculars({super.key, this.extracurricular});

  @override
  State<AddEditExtracurriculars> createState() =>
      _AddEditExtracurricularsState();
}

class _AddEditExtracurricularsState extends State<AddEditExtracurriculars> {
  final titleController = TextEditingController();
  final minutesController = TextEditingController();
  int selectedIndex = -1;
  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  late FirebaseController firebaseController;
  late StudentState studentState;
  @override
  void initState() {
    firebaseController = context.read<FirebaseController>();
    if (widget.extracurricular != null) {
      titleController.text = widget.extracurricular!.title;
      minutesController.text = widget.extracurricular!.time.toString();
      selectedIndex = widget.extracurricular!.dayIndex;
    }
    studentState = context.read<StudentState>();
    super.initState();
  }

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
                    width: 85.w,
                    child: Text(
                      widget.extracurricular == null
                          ? 'Add an Extracurricular'
                          : 'Edit Extracurricular',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 85.w,
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
                    width: 60.w,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        for (int i = 0; i < days.length; i++)
                          Dugme(
                            day: days[i],
                            index: i,
                            selectedIndex: selectedIndex,
                            ontap: () {
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
                  width: 60.w,
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
                  width: 70.w,
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
                    width: 40.w,
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
                        if (selectedIndex == -1) {
                          Get.snackbar(
                              "A required field is mising", 'Please enter day');
                          return;
                        }
                        if (minutesController.text.isEmpty ||
                            int.tryParse(minutesController.text) == null) {
                          Get.snackbar("A required field is mising",
                              'Please enter time');
                          return;
                        }
                        if (firebaseController.currentUser?.breakday ==
                            selectedIndex) {
                          Get.snackbar("Breakday", 'Please select another day');
                          return;
                        }
                        if (widget.extracurricular != null) {
                          if (widget.extracurricular!.dayIndex !=
                              selectedIndex) {
                            widget.extracurricular!.index = 1000;
                          }
                          final prevIndex = widget.extracurricular!.dayIndex;
                          final prevTime = widget.extracurricular!.time;
                          widget.extracurricular!.dayIndex = selectedIndex;
                          widget.extracurricular!.time =
                              int.parse(minutesController.text);
                          widget.extracurricular!.title = titleController.text;
                          firebaseController.updateExtracurriculars(
                              widget.extracurricular!, prevIndex, prevTime);
                        } else {
                          firebaseController
                              .addExtracurricular(
                                  title: titleController.text,
                                  time: int.parse(minutesController.text),
                                  day: selectedIndex)
                              .then((value) {
                            studentState.addExtracurricular(value);
                          });
                        }
                        Navigator.of(context).pop();
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
