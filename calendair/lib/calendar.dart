import 'package:calendair/calendarAssignment.dart';
import 'package:calendair/models/Assigments.dart';
import 'package:calendair/popUpsConfidenceMeter.dart';
import 'package:calendair/reminder.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'Classes/googleClassroom.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final gc = Get.find<GoogleClassroom>();
  late final List<DragAndDropList> _contents = [
    DragAndDropList(verticalAlignment: CrossAxisAlignment.stretch, children: [
      DragAndDropItem(
          child:
              CalendarAssignment(as: Assigments("Finish Bio Lab", 30, false))),
    ]),
    DragAndDropList(
      contentsWhenEmpty: SizedBox(),
      children: [
        DragAndDropItem(
            child:
                CalendarAssignment(as: Assigments("Finish Bio Lab", 30, true))),
        DragAndDropItem(
            child: CalendarAssignment(
                as: Assigments("Finish Bio Lab", 30, false))),
      ],
    ),
    DragAndDropList(
      canDrag: false,
      children: [
        DragAndDropItem(
            child: CalendarAssignment(
                as: Assigments("Finish Bio Lab", 30, false))),
        DragAndDropItem(
            child: CalendarAssignment(
                as: Assigments("Finish Bio Lab", 30, false))),
      ],
    ),
    DragAndDropList(
      children: [
        DragAndDropItem(
            child: CalendarAssignment(
                as: Assigments("Finish Bio Lab", 30, false))),
        DragAndDropItem(
            child: CalendarAssignment(
                as: Assigments("Finish Bio Lab", 30, false))),
      ],
    ),
    DragAndDropList(
      children: [
        DragAndDropItem(
            child: CalendarAssignment(
                as: Assigments("Finish Bio Lab", 30, false))),
        DragAndDropItem(
            child: CalendarAssignment(
                as: Assigments("Finish Bio Lab", 30, false))),
      ],
    ),
    DragAndDropList(
      children: [
        DragAndDropItem(
            child: CalendarAssignment(
                as: Assigments("Finish Bio Lab", 30, false))),
        DragAndDropItem(
            child: CalendarAssignment(
                as: Assigments("Finish Bio Lab", 30, false))),
      ],
    ),
    DragAndDropList(
      children: [
        DragAndDropItem(
            child: CalendarAssignment(
                as: Assigments("Finish Bio Lab", 30, false))),
        DragAndDropItem(
            child: CalendarAssignment(
                as: Assigments("Finish Bio Lab", 30, false))),
      ],
    ),
  ];
  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  double _value = 21.0;
  final days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];
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
                Row(
                    children: days
                        .map((e) => Expanded(
                              child: Container(
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.13),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ))
                        .toList()),
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
                    Row(
                      children: days
                          .map((e) => Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            94, 158, 197, 1),
                                        width: 2)),
                              )))
                          .toList(),
                    ),
                    Obx(
                      () => DragAndDropLists(
                        itemDragHandle: !gc.edit.value
                            ? DragHandle(child: SizedBox())
                            : null,
                        listDragHandle: !gc.edit.value
                            ? DragHandle(child: SizedBox())
                            : null,
                        contentsWhenEmpty: Text('aaa'),
                        lastListTargetSize: 0,
                        lastItemTargetHeight: 100,
                        //disableScrolling: true,
                        children: _contents,
                        onItemReorder: _onItemReorder,
                        onListReorder: _onListReorder,
                        axis: Axis.horizontal,
                        listWidth: width / 7,
                        listPadding: EdgeInsets.symmetric(horizontal: 0),
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
              child: Row(
                children: days
                    .map((e) => Expanded(
                            child: Container(
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
                                child: Container(
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        "65 Minutes",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                144, 144, 144, 1)),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
