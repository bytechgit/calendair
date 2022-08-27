import 'package:calendair/models/Assigments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'Classes/googleClassroom.dart';

class CalendarAssignment extends StatefulWidget {
  Assigments as;
  CalendarAssignment({
    Key? key,
    required this.as,
  }) : super(key: key);

  @override
  State<CalendarAssignment> createState() => _CalendarAssignmentState();
}

class _CalendarAssignmentState extends State<CalendarAssignment> {
  final gc = Get.find<GoogleClassroom>();
  bool? value = false;
  @override
  void initState() {
    value = widget.as.checked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Container(
        padding: const EdgeInsets.all(5),
        color: const Color.fromRGBO(217, 237, 250, 1),
        child: Row(children: [
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
                                  Radius.circular(5.0))), // Rounded Checkbox

                          onChanged: (inputValue) {
                            setState(() {
                              widget.as.checked = inputValue;
                              print(value);
                            });
                          },
                          value: widget.as.checked,
                        )
                      : Image.asset('assets/images/3line.png'),
                ),
              )),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  widget.as.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${widget.as.duration} Minutes",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12,
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
