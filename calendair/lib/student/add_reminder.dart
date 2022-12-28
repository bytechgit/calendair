import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/student/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Reminder extends StatefulWidget {
  const Reminder({Key? key}) : super(key: key);

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  late final FirebaseController firebaseController;
  @override
  void initState() {
    firebaseController = context.read<FirebaseController>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  DateTime date = DateTime.now();
  final titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: const Calendar(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.fade,
            );
            return false;
          },
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: 50.w,
                      child: const FittedBox(
                        child: Text(
                          'Reminder',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
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
                              color: Color.fromRGBO(38, 64, 78, 1),
                              fontSize: 25),
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
                                backgroundColor:
                                    Color.fromRGBO(94, 159, 197, 1),
                                itemStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                doneStyle: TextStyle(
                                    color: Colors.white, fontSize: 16)),
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
                          if (date.weekday - 1 ==
                              firebaseController.currentUser?.breakday) {
                            Get.snackbar("Breakday", 'Select another day');
                            return;
                          }
                          if (titleController.text == "") {
                            Get.snackbar("Title", 'Enter title');
                            return;
                          }
                          firebaseController.addReminderStudent(
                              date: date, title: titleController.text);
                          Navigator.of(context).pop();
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const Calendar(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          );
                        },
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Add',
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
      ),
    );
  }
}
