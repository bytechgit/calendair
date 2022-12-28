import 'package:calendair/schedule/schedule_element_reminder.dart';
import 'package:flutter/material.dart';

class CalendarReminder extends StatelessWidget {
  final ScheduleElementReminder reminder;
  const CalendarReminder({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: reminder.color,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                reminder.title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          )),
    );
  }
}
