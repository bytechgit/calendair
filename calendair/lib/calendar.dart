import 'dart:developer';

import 'package:calendair/calendarAssignment.dart';
import 'package:calendair/classes/scheduleController.dart';
import 'package:calendair/models/Assigments.dart';
import 'package:calendair/addReminderStudent.dart';
import 'package:calendair/toDo.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'Classes/googleClassroom.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final gc = Get.find<GoogleClassroom>();
  final sc = Get.find<ScheduleCintroller>();
  late final List<DragAndDropList> _contents = [];
  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
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

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _controllers = LinkedScrollControllerGroup();
    calendarController = _controllers.addAndGet();
    avgController = _controllers.addAndGet();
    gridController = _controllers.addAndGet();
    appBarController = _controllers.addAndGet();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    calendarController.dispose();
    avgController.dispose();
    super.dispose();
  }

  double _value = 21.0;
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
          child: SafeArea(
            child: Column(
              children: [
                const Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Weekly Average : 58 mins",
                      style: TextStyle(
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
                            Get.to(
                              ToDo(
                                index: i,
                                day: days[i],
                                fromCalendar: true,
                              ),
                              transition: Transition.circularReveal,
                              duration: const Duration(milliseconds: 800),
                            )!
                                .then((value) {
                              print(Get.currentRoute);
                              if (Get.currentRoute == "/Calendar") {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeRight,
                                  DeviceOrientation.landscapeLeft,
                                ]);
                              }
                            });
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
        ),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(94, 158, 197, 1),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Obx(
                () => Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      controller: gridController,
                      child: Row(
                        children: days
                            .map((e) => Container(
                                  width: width / 7,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromRGBO(
                                              94, 158, 197, 1),
                                          width: 2)),
                                ))
                            .toList(),
                      ),
                    ),
                    Obx(
                      () => DragAndDropLists(
                        scrollController: calendarController,
                        itemDragHandle: !gc.edit.value
                            ? const DragHandle(child: SizedBox())
                            : null,
                        listDragHandle: !gc.edit.value
                            ? const DragHandle(child: SizedBox())
                            : null,

                        lastListTargetSize: 0,
                        lastItemTargetHeight: 100,
                        //disableScrolling: true,
                        children: sc.scheduleElements.value.map((list) {
                          return DragAndDropList(
                              contentsWhenEmpty: const SizedBox(),
                              verticalAlignment: CrossAxisAlignment.stretch,
                              children: list
                                  .map(
                                    (e) => DragAndDropItem(
                                      child: CalendarAssignment(
                                        scheduleElement: e,
                                      ),
                                      canDrag: true,
                                      // e.type == "reminder" ? false : true,
                                    ),
                                  )
                                  .toList(),
                              canDrag: false);
                        }).toList(),
                        onItemReorder: _onItemReorder,
                        onListReorder: _onListReorder,
                        axis: Axis.horizontal,
                        listWidth: width / 7,
                        listPadding: const EdgeInsets.symmetric(horizontal: 0),
                      ),
                    ),
                    if (!gc.edit.value)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              gc.edit.value = !gc.edit.value;
                            },
                            child: Image.asset(
                              'assets/images/calendarhammer.png',
                              width: 40,
                            ),
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            if (gc.edit.value == true) {
                              gc.edit.value = false;
                            } else {
                              await SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeRight,
                                DeviceOrientation.landscapeLeft,
                                DeviceOrientation.portraitUp,
                                DeviceOrientation.portraitDown,
                              ]);
                              Get.to(
                                const Reminder(),
                                transition: Transition.circularReveal,
                                duration: const Duration(milliseconds: 800),
                              );
                            }
                          },
                          child: Obx(
                            () => Image.asset(
                              gc.edit.value
                                  ? 'assets/images/calendaredited.png'
                                  : 'assets/images/calendarplus.png',
                              width: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                                  child: Text(
                                    "${sc.totalTimes.value[d]} Minutes",
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(144, 144, 144, 1)),
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
      ),
    );
  }
}
