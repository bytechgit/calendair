import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/models/notification_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:expandable/expandable.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  final reminderController = ExpandableController();
  final updatesController = ExpandableController();
  final assignmentsController = ExpandableController();
  late FirebaseController firebaseController;
  Map<String, NotificationSettingsModel> notification = {
    "1": NotificationSettingsModel(
        "1",
        "Remind to complete unfinished assignments the day before the due date",
        'reminder'),
    "2": NotificationSettingsModel(
        "2", "Send inspirational quote to encourage studying", 'reminder'),
    "3": NotificationSettingsModel(
        "3", "Update on teacher announcements", 'updates'),
    "4": NotificationSettingsModel(
        "4", "Update on confidence meter popups", 'updates'),
    "5": NotificationSettingsModel(
        "5", "Update on TOS and app  development updates", 'updates'),
    "6": NotificationSettingsModel(
        "6", "Send when a new assignment is posted", 'assignments'),
    "7": NotificationSettingsModel(
        "7", "Send when a new exam is posted", 'assignments'),
    "8": NotificationSettingsModel(
        "8",
        "Send notification when assignment is done (via timer) ",
        'assignments'),
    "9": NotificationSettingsModel(
        "9",
        "Keep notification pinned with an ongoing assignment timer",
        'assignments'),
    "10": NotificationSettingsModel(
        "10", "Notify when teacher edits an assignment", 'assignments'),
  };
  @override
  void initState() {
    firebaseController = context.read<FirebaseController>();
    for (var element in firebaseController.currentUser!.notifications.entries) {
      notification[element.key]?.checked = element.value;
    }
    reminderController.addListener(() {
      setState(() {});
    });
    updatesController.addListener(() {
      setState(() {});
    });
    assignmentsController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.of(context).pop();
            //inspect(gc.courses);
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
                    width: 70.w,
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
                width: 70.w,
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
                        children: notification.entries
                            .where(
                                (element) => element.value.type == "reminder")
                            .map(
                              (e) => Row(
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          e.value.text,
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
                                            e.value.checked =
                                                inputValue ?? false;
                                            firebaseController
                                                .updateNotificationSettings(
                                                    e.value);
                                          });
                                        },
                                        value: e.value.checked,
                                      )),
                                ],
                              ),
                            )
                            .toList())),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Container(
                  width: 70.w,
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
                          children: notification.entries
                              .where(
                                  (element) => element.value.type == "updates")
                              .map(
                                (e) => Row(
                                  children: [
                                    Flexible(
                                      flex: 6,
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            e.value.text,
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
                                              e.value.checked =
                                                  inputValue ?? false;
                                              firebaseController
                                                  .updateNotificationSettings(
                                                      e.value);
                                            });
                                          },
                                          value: e.value.checked,
                                        )),
                                  ],
                                ),
                              )
                              .toList())),
                ),
              ),
              Container(
                width: 70.w,
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
                    children: notification.entries
                        .where((element) => element.value.type == "assignments")
                        .map(
                          (e) => Row(
                            children: [
                              Flexible(
                                flex: 6,
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      e.value.text,
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
                                        e.value.checked = inputValue ?? false;
                                        firebaseController
                                            .updateNotificationSettings(
                                                e.value);
                                      });
                                    },
                                    value: e.value.checked,
                                  )),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
