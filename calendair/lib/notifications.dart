import 'package:calendair/models/Reminder.dart';
import 'package:calendair/settings.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'classes/googleClassroom.dart';
import 'bottomNavBar.dart';
import 'dashboard.dart';
import 'models/nbar.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final gc = Get.find<GoogleClassroom>();
  ExpandableController reminderController = ExpandableController();
  ExpandableController updatesController = ExpandableController();
  ExpandableController assignmentsController = ExpandableController();
  final reminders = [
    Reminder(
        'Remind to complete unfinished assignments the day before the due date',
        false),
    Reminder('Send inspirational quote to encourage studying', false),
  ];
  @override
  Widget build(BuildContext context) {
    reminderController.addListener(() {
      setState(() {});
    });
    updatesController.addListener(() {
      setState(() {});
    });
    assignmentsController.addListener(() {
      setState(() {});
    });
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
                  const Settings(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              })
        ],
        selected: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              const SizedBox(
                width: double.infinity,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 40),
                  child: SizedBox(
                    width: width * 0.7,
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: width * 0.7,
                decoration: BoxDecoration(
                    color: reminderController.expanded
                        ? const Color.fromRGBO(93, 159, 196, 1)
                        : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                padding: const EdgeInsets.all(10),
                child: ExpandablePanel(
                    controller: reminderController,
                    header: const FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Remiders",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                    collapsed: const SizedBox(),
                    expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: reminders
                            .map(
                              (e) => Row(
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          e.text,
                                          style: const TextStyle(fontSize: 20),
                                        )),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Checkbox(
                                        activeColor: Colors.green,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    5.0))), // Rounded Checkbox

                                        onChanged: (inputValue) {
                                          setState(() {
                                            e.checked = inputValue;
                                            // print(value);
                                          });
                                        },
                                        value: e.checked,
                                      )),
                                ],
                              ),
                            )
                            .toList())),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Container(
                  width: width * 0.7,
                  decoration: BoxDecoration(
                      color: updatesController.expanded
                          ? const Color.fromRGBO(93, 159, 196, 1)
                          : Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  padding: const EdgeInsets.all(10),
                  child: ExpandablePanel(
                      controller: updatesController,
                      header: const FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Updates",
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      collapsed: const SizedBox(),
                      expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: reminders
                              .map(
                                (e) => Row(
                                  children: [
                                    Flexible(
                                      flex: 6,
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            e.text,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          )),
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: Checkbox(
                                          activeColor: Colors.green,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      5.0))), // Rounded Checkbox

                                          onChanged: (inputValue) {
                                            setState(() {
                                              e.checked = inputValue;
                                              // print(value);
                                            });
                                          },
                                          value: e.checked,
                                        )),
                                  ],
                                ),
                              )
                              .toList())),
                ),
              ),
              Container(
                width: width * 0.7,
                decoration: BoxDecoration(
                    color: assignmentsController.expanded
                        ? const Color.fromRGBO(93, 159, 196, 1)
                        : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                padding: const EdgeInsets.all(10),
                child: ExpandablePanel(
                    controller: assignmentsController,
                    header: const FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Assignments",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                    collapsed: const SizedBox(),
                    expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: reminders
                            .map(
                              (e) => Row(
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          e.text,
                                          style: const TextStyle(fontSize: 20),
                                        )),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Checkbox(
                                        activeColor: Colors.green,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    5.0))), // Rounded Checkbox

                                        onChanged: (inputValue) {
                                          setState(() {
                                            e.checked = inputValue;
                                            // print(value);
                                          });
                                        },
                                        value: e.checked,
                                      )),
                                ],
                              ),
                            )
                            .toList())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
