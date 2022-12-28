import 'package:calendair/schedule/schedule_element_assignment.dart';
import 'package:calendair/student/todo_start.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ToDo extends StatefulWidget {
  final ScheduleElementAssignment element;
  const ToDo({super.key, required this.element});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: GestureDetector(
        onTap: () {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: TodoStart(
              element: widget.element,
            ),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.fade,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                activeColor: Colors.green,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                onChanged: (inputValue) {
                  setState(() {
                    widget.element.finish(inputValue ?? false);
                  });
                },
                value: widget.element.finished,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  height: 30,
                  width: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: widget.element.color),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.element.title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${widget.element.duration} Minutes",
                    style: const TextStyle(
                        fontSize: 17, color: Color.fromRGBO(75, 76, 77, 1)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
