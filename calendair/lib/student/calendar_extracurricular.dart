import 'package:calendair/schedule/schedule_element_extracurricular.dart';
import 'package:flutter/material.dart';

class CalendarExtracurricular extends StatefulWidget {
  final ScheduleElementExtracurricular extracurricular;
  final int week;
  final bool edit;
  const CalendarExtracurricular(
      {super.key,
      required this.extracurricular,
      required this.edit,
      required this.week});

  @override
  State<CalendarExtracurricular> createState() =>
      _CalendarExtracurricularState();
}

class _CalendarExtracurricularState extends State<CalendarExtracurricular> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: widget.extracurricular.color,
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
                          widget.extracurricular.finish(
                              finish: inputValue ?? false, week: widget.week);
                        });
                      },
                      value: widget.extracurricular.finished(widget.week),
                    )
                  : Image.asset('assets/images/3line.png'),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  widget.extracurricular.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${widget.extracurricular.duration} Minutes",
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
