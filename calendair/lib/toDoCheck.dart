import 'package:calendair/dayToDo.dart';
import 'package:calendair/models/schedule/scheduleElement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToDoCheck extends StatefulWidget {
  ScheduleElement el;
  ToDoCheck({Key? key, required this.el}) : super(key: key);

  @override
  State<ToDoCheck> createState() => _ToDoCheckState();
}

class _ToDoCheckState extends State<ToDoCheck> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // SizedBox(
          //   width: width * 0.15,
          // ),
          GestureDetector(
            child: Container(
              height: 35,
              width: width * 0.08,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                  color: widget.el.finished == false
                      ? Colors.white
                      : Colors.green),
              child: widget.el.finished == true
                  ? const Icon(
                      Icons.done,
                      color: Colors.white,
                    )
                  : null,
            ),
            onTap: () {
              setState(() {
                widget.el.finished = !widget.el.finished;
                widget.el.finish(widget.el.finished);
              });
            },
          ),
          // Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              height: 30,
              width: 15,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: widget.el.color),
            ),
          ),
          // Expanded(child: Container()),
          Expanded(
            child: InkWell(
              onTap: () {
                Get.to(
                  DayToDo(
                    sc: widget.el,
                  ),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.el.title_,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${widget.el.time} Minutes",
                        style: const TextStyle(
                            fontSize: 17, color: Color.fromRGBO(75, 76, 77, 1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: width * 0.15,
          // ),
        ],
      ),
    );
  }
}

//Color.fromRGBO(170, 227, 155, 1)