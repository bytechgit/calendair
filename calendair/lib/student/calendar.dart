import 'dart:developer';

import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/controllers/schedule_controller.dart';
import 'package:calendair/controllers/schedule_lists.dart';
import 'package:calendair/student/add_reminder.dart';
import 'package:calendair/student/calendar_schedule_element.dart';
import 'package:calendair/student/to_do.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final sc = Get.find<ScheduleController>();
  final scheduleLists = Get.find<ScheduleLists>();
  late final List<DragAndDropList> _contents = [];
  bool edit = false;
  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    if (newListIndex != firebaseController.currentUser!.breakday &&
        newListIndex != firebaseController.currentUser!.breakday + 7) {
      setState(() {
        var movedI = sc.removeFromScheduleElements(
            listIndex: oldListIndex, index: oldItemIndex);
        sc.addInScheduleElements(
            newListIndex: newListIndex,
            index: newItemIndex,
            se: movedI,
            oldListIndex: oldListIndex);
        // gc.scheduleElements.value[oldListIndex].removeAt(oldItemIndex);
        //gc.scheduleElements.value[newListIndex].insert(newItemIndex, movedI);
        // var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
        // _contents[newListIndex].children.insert(newItemIndex, movedItem);
      });
    }
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }

  late LinkedScrollControllerGroup _controllers;
  late ScrollController calendarController;
  late ScrollController avgController;
  late ScrollController gridController;
  late ScrollController appBarController;
  int dayOffset = 0;
  DateTime startDate =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  late FirebaseController firebaseController;
  @override
  void initState() {
    super.initState();
    firebaseController = context.read<FirebaseController>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _controllers = LinkedScrollControllerGroup();
    calendarController = _controllers.addAndGet();
    avgController = _controllers.addAndGet();
    gridController = _controllers.addAndGet();
    appBarController = _controllers.addAndGet();
    calendarController.addListener(() {
      int offset = (calendarController.offset / (Get.width / 7)).floor();
      if (offset != dayOffset) {
        setState(() {
          dayOffset = offset;
        });
      }
    });
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    calendarController.dispose();
    avgController.dispose();
    super.dispose();
  }

  final days = [
    'Mon',
    'Tues',
    'Wed',
    'Thurs',
    'Fri',
    'Sat',
    'Sun',
    'Mon',
    'Tues',
    'Wed',
    'Thurs',
    'Fri',
    'Sat',
    'Sun'
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Center(
          child: Column(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${DateFormat("MM/dd").format(startDate.add(Duration(days: dayOffset)))} - ${DateFormat("MM/dd").format(startDate.add(Duration(days: 6 + dayOffset)))}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: appBarController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < days.length; i++)
                      InkWell(
                        onTap: (() {
                          Get.off(
                            ToDo(
                              index: i,
                              day: days[i],
                              fromCalendar: true,
                            ),
                            transition: Transition.circularReveal,
                            duration: const Duration(milliseconds: 800),
                          );
                        }),
                        child: SizedBox(
                          width: width / 7,
                          // constraints:
                          //  BoxConstraints(maxWidth: width / 7),
                          child: FittedBox(
                            alignment: Alignment.center,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              days[i],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(94, 158, 197, 1),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: gridController,
                  child: Row(
                    children: days
                        .map(
                          (e) => Container(
                            width: width / 7,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(94, 158, 197, 1),
                                    width: 2)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Obx(
                  () => DragAndDropLists(
                    removeTopPadding: true,
                    scrollController: calendarController,
                    itemDragHandle:
                        !edit ? const DragHandle(child: SizedBox()) : null,
                    listDragHandle:
                        !edit ? const DragHandle(child: SizedBox()) : null,
                    lastListTargetSize: 0,
                    lastItemTargetHeight: 100,
                    //disableScrolling: true,
                    children: [
                      for (int i = 0;
                          i < scheduleLists.scheduleElements.value.length;
                          i++) ...{
                        if (firebaseController.currentUser!.breakday == -1 ||
                            firebaseController.currentUser!.breakday != i &&
                                firebaseController.currentUser!.breakday !=
                                    i - 7) ...{
                          DragAndDropList(
                              contentsWhenEmpty: const SizedBox(),
                              verticalAlignment: CrossAxisAlignment.stretch,
                              children: scheduleLists.scheduleElements.value[i]
                                  .map(
                                    (e) => DragAndDropItem(
                                      child: CalendarScheduleElement(
                                        scheduleElement: e,
                                        edit: edit,
                                      ),
                                      canDrag: true,
                                      // e.type == "reminder" ? false : true,
                                    ),
                                  )
                                  .toList(),
                              canDrag: false),
                        } else
                          DragAndDropList(
                              contentsWhenEmpty: const SizedBox(),
                              verticalAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DragAndDropItem(
                                    child: const Center(
                                        child: Text(
                                      'Break day',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    canDrag: false)
                              ],
                              canDrag: false),
                      }
                    ],

                    // children: sc.scheduleElements.value.map((list) {
                    //   return DragAndDropList(
                    //       contentsWhenEmpty: const SizedBox(),
                    //       verticalAlignment: CrossAxisAlignment.stretch,
                    //       children: list
                    //           .map(
                    //             (e) => DragAndDropItem(
                    //               child: CalendarAssignment(
                    //                 scheduleElement: e,
                    //               ),
                    //               canDrag: true,
                    //               // e.type == "reminder" ? false : true,
                    //             ),
                    //           )
                    //           .toList(),
                    //       canDrag: false);
                    // }).toList(),
                    onItemReorder: _onItemReorder,
                    onListReorder: _onListReorder,
                    axis: Axis.horizontal,
                    listWidth: width / 7,
                    listPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                ),
                if (!edit)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 80.0, top: 8.0, right: 8.0, bottom: 8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                        child: Image.asset(
                          'assets/images/calendarhammer.png',
                          width: 40,
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: 40,
                            height: 40,
                            color: Color.fromARGB(255, 210, 210, 210),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        if (edit == true) {
                          setState(() {
                            edit = false;
                          });
                        } else {
                          Get.off(
                            const Reminder(),
                            transition: Transition.circularReveal,
                            duration: const Duration(milliseconds: 800),
                          );
                        }
                      },
                      child: Image.asset(
                        edit
                            ? 'assets/images/calendaredited.png'
                            : 'assets/images/calendarplus.png',
                        width: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: avgController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int d = 0; d < 14; d++)
                    Container(
                      width: width / 7,
                      decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: Color.fromRGBO(94, 158, 197, 1),
                                width: 2),
                            right: BorderSide(
                                color: Color.fromRGBO(94, 158, 197, 1),
                                width: 2),
                            top: BorderSide(
                                color: Color.fromRGBO(94, 158, 197, 1),
                                width: 2)),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: FittedBox(
                                child: Obx(
                                  () => Text(
                                    "${scheduleLists.totalTimes.value[d]} Minutes",
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(144, 144, 144, 1)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}