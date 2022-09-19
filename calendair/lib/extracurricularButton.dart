import 'package:calendair/Classes/ExtButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Classes/scheduleController.dart';

class ExtracurricularButton extends StatefulWidget {
  final String text;
  final int index;
  final bool ext;

  const ExtracurricularButton(
      {Key? key, required this.text, required this.index, this.ext = true})
      : super(key: key);

  @override
  State<ExtracurricularButton> createState() => _ExtracurricularButtonState();
}

class _ExtracurricularButtonState extends State<ExtracurricularButton> {
  final extb = Get.find<ExtButton>();
  final sc = Get.find<ScheduleCintroller>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.ext == false) {
          if (widget.index == extb.breakdayIndex.value) {
            extb.breakdayIndex.value = -1;
          } else {
            if (sc.scheduleElements.value[widget.index].isEmpty &&
                sc.scheduleElements.value[widget.index + 7].isEmpty) {
              extb.breakdayIndex.value = widget.index;
            } else {
              Get.snackbar(
                  "Change schedule", "There are tasks assigned for that day");
            }
          }
        } else {
          if (extb.breakdayIndex.value != widget.index) {
            extb.index.value = widget.index;
          } else {
            Get.snackbar("Break day", "Choose another day");
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
                color: widget.ext
                    ? extb.index.value == widget.index
                        ? const Color.fromRGBO(94, 159, 197, 1)
                        : const Color.fromRGBO(217, 217, 217, 1)
                    : extb.breakdayIndex.value == widget.index
                        ? const Color.fromRGBO(94, 159, 197, 1)
                        : const Color.fromRGBO(217, 217, 217, 1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
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
      ),
    );
  }
}
