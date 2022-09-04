import 'package:calendair/Classes/firestore.dart';
import 'package:calendair/models/CustomCourse.dart';
import 'package:calendair/models/reminderModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'bottomNavBar.dart';
import 'models/nbar.dart';

class AddClassReminder extends StatefulWidget {
  final CustomCourse course;
  final ReminderModel reminder;
  const AddClassReminder(
      {Key? key, required this.course, required this.reminder})
      : super(key: key);

  @override
  State<AddClassReminder> createState() => _AddClassReminderState();
}

class _AddClassReminderState extends State<AddClassReminder> {
  final titleController = TextEditingController();
  @override
  void initState() {
    titleController.text = widget.reminder.title;
    super.initState();
  }

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
                child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              width: width * 0.5,
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
            width: width * 0.8,
            child: const Divider(
              thickness: 10,
              height: 15,
              color: Color.fromRGBO(223, 223, 223, 1),
            ),
          ),
          SizedBox(
            width: width * 0.7,
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
              width: width * 0.7,
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  filled: true,
                  hintStyle: const TextStyle(
                      color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                  //hintText: widget.reminder.title,
                  fillColor: const Color.fromRGBO(94, 159, 197, 1),
                ),
                onChanged: (text) {
                  widget.reminder.title = text;
                },
              ),
            ),
          ),
          SizedBox(
            width: width * 0.7,
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
                    maxTime: DateTime.now().add(Duration(days: 600)),
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
                    widget.reminder.date = Timestamp.fromDate(d);
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
              child: Container(
                width: width * 0.7,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromRGBO(94, 159, 197, 1),
                ),
                child: Center(
                  child: Text(
                    DateFormat("MM/dd/yy")
                        .format(widget.reminder.date.toDate()),
                    style: const TextStyle(
                        color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: SizedBox(
              width: width * 0.6,
              height: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                    primary: const Color.fromRGBO(94, 159, 197, 1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                onPressed: () {
                  Firestore().updateReminder(r: widget.reminder);
                  Get.back();
                },

                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Update',
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
        ]))));
  }
}
