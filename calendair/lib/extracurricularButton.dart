import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'classes/scheduleController.dart';

class ExtracurricularButton extends StatefulWidget {
  final String text;
  final int index;
  final int selectedIndex;
  final Function() onClick;

  const ExtracurricularButton(
      {Key? key,
      required this.text,
      required this.index,
      this.selectedIndex = -1,
      required this.onClick})
      : super(key: key);

  @override
  State<ExtracurricularButton> createState() => _ExtracurricularButtonState();
}

class _ExtracurricularButtonState extends State<ExtracurricularButton> {
  final sc = Get.find<ScheduleController>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick, //() {
      // if (widget.ext == false) {
      //   if (widget.index == extb.breakdayIndex.value) {
      //     extb.breakdayIndex.value = -1;
      //   } else {
      //     if (scheduleLists.scheduleElements.value[widget.index].isEmpty &&
      //         scheduleLists
      //             .scheduleElements.value[widget.index + 7].isEmpty) {
      //       extb.breakdayIndex.value = widget.index;
      //     } else {
      //       Get.snackbar(
      //           "Change schedule", "There are tasks assigned for that day");
      //     }
      //   }
      // } else {
      //   if (extb.breakdayIndex.value != widget.index) {
      //     extb.index.value = widget.index;
      //   } else {
      //     Get.snackbar("Break day", "Choose another day");
      //   }
      // }
      //},
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: widget.index == widget.selectedIndex
                ? const Color.fromRGBO(94, 159, 197, 1)
                : const Color.fromRGBO(217, 217, 217, 1),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
