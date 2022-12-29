import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/controllers/teacher_state.dart';
import 'package:calendair/models/course_model.dart';
import 'package:calendair/models/remider_model.dart';
import 'package:calendair/student_teacher/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AddUpdateReminder extends StatefulWidget {
  final CourseModel course;
  final ReminderModel? reminder;
  const AddUpdateReminder({super.key, required this.course, this.reminder});

  @override
  State<AddUpdateReminder> createState() => _AddUpdateReminderState();
}

class _AddUpdateReminderState extends State<AddUpdateReminder> {
  late FirebaseController firebaseController;
  late TeacherState teacherState;
  final titleController = TextEditingController();
  DateTime date = DateTime.now();
  @override
  void initState() {
    firebaseController = context.read<FirebaseController>();
    teacherState = context.read<TeacherState>();
    if (widget.reminder != null) {
      titleController.text = widget.reminder!.title;
      date = widget.reminder!.date.toDate();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
        bottomNavigationBar: NavBar(
          navBarItems: [
            NavBarItem(
                image: 'home',
                onclick: () {
                  Get.until((route) =>
                      (route as GetPageRoute).routeName == '/TeacherDashboard');
                }),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: 80.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.course.className,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 35,
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
                SizedBox(
                  width: 70.w,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Reminder Title',
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
                  padding: const EdgeInsets.only(top: 5.0, bottom: 30),
                  child: SizedBox(
                    width: 70.w,
                    //height: 40,
                    child: TextField(
                      controller: titleController,
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
                        hintText: "Please Enter",
                        fillColor: const Color.fromRGBO(94, 159, 197, 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 70.w,
                  child: const Text(
                    'Date of Reminder',
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
                  child: InkWell(
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime:
                              DateTime.now().add(const Duration(days: 600)),
                          theme: const DatePickerTheme(
                              headerColor: Color.fromARGB(255, 176, 176, 176),
                              backgroundColor: Color.fromRGBO(94, 159, 197, 1),
                              itemStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              doneStyle:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          onChanged: (date) {}, onConfirm: (d) {
                        setState(() {
                          date = d;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Container(
                      width: 70.w,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(94, 159, 197, 1),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat("MM/dd/yy").format(date),
                          style: const TextStyle(
                              color: Color.fromRGBO(38, 64, 78, 1),
                              fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    width: 60.w,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      onPressed: () {
                        if (titleController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Enter reminder title"),
                            ),
                          );
                          return;
                        }
                        if (widget.reminder == null) {
                          firebaseController
                              .addReminder(
                                  course: widget.course,
                                  date: date,
                                  title: titleController.text)
                              .then((value) {
                            teacherState.addReminder(
                                value, widget.course.docId);
                          });
                        } else {
                          widget.reminder!.date = Timestamp.fromDate(date);
                          widget.reminder!.title = titleController.text;
                          firebaseController.updateReminder(
                              r: widget.reminder!);
                          teacherState.update();
                        }
                        Get.back();
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.reminder == null ? 'Send' : 'Update',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 35,
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
        ),
      ),
    );
  }
}
