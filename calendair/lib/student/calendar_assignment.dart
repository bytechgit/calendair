import 'package:calendair/schedule/schedule_element_assignment.dart';
import 'package:flutter/material.dart';

class CalendarAssignment extends StatefulWidget {
  final ScheduleElementAssignment assignment;
  final bool edit;
  const CalendarAssignment(
      {super.key, required this.assignment, required this.edit});

  @override
  State<CalendarAssignment> createState() => _CalendarAssignmentState();
}

class _CalendarAssignmentState extends State<CalendarAssignment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: widget.assignment.color,
        ),
        child: Row(children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: !widget.edit
                  ? Checkbox(
                      activeColor: Colors.green,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      onChanged: (inputValue) {
                        setState(() {
                          widget.assignment.finish(inputValue ?? false);
                        });
                      },
                      value: widget.assignment.finished,
                    )
                  : Image.asset('assets/images/3line.png'),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  widget.assignment.prefixtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${widget.assignment.duration} Minutes",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(135, 129, 124, 1)),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
