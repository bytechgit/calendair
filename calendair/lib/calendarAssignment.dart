import 'package:calendair/models/Assigments.dart';
import 'package:calendair/models/ScheduleElementModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'Classes/googleClassroom.dart';

class CalendarAssignment extends StatefulWidget {
  ScheduleElement scheduleElement;
  CalendarAssignment({
    Key? key,
    required this.scheduleElement,
  }) : super(key: key);

  @override
  State<CalendarAssignment> createState() => _CalendarAssignmentState();
}

class _CalendarAssignmentState extends State<CalendarAssignment> {
  final gc = Get.find<GoogleClassroom>();
  bool? value = false;
  @override
  void initState() {
    value = widget.scheduleElement.checked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: widget.scheduleElement.type == "extracurriculars"
            ? BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                color: widget
                    .scheduleElement.color, // Color.fromRGBO(217, 237, 250, 1),
              )
            : BoxDecoration(
                // borderRadius: BorderRadius.all(Radius.circular(50)),
                color: widget.scheduleElement.color,
              ),
        child: widget.scheduleElement is ScheduleElementReminder
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    widget.scheduleElement.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            : Row(children: [
                Expanded(
                    flex: 1,
                    child: Obx(
                      () => Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: !gc.edit.value
                            ? Checkbox(
                                activeColor: Colors.green,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            5.0))), // Rounded Checkbox

                                onChanged: (inputValue) {
                                  setState(() {
                                    widget.scheduleElement.checked =
                                        inputValue ?? false;
                                    print(value);
                                  });
                                },
                                value: widget.scheduleElement.checked,
                              )
                            : Image.asset('assets/images/3line.png'),
                      ),
                    )),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text(
                        widget.scheduleElement.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${widget.scheduleElement.time} Minutes",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(135, 129, 124, 1)),
                      )
                    ],
                  ),
                )
              ]),
      ),
    );
  }
}
