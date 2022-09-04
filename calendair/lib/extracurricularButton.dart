import 'package:calendair/classes/ExtButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.ext == false) {
          if (extb.day.value == widget.text) {
            extb.day.value = "";
          } else {
            extb.day.value = widget.text;
          }
        } else {
          extb.day.value = widget.text;
        }
        extb.index.value = widget.index;
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
                color: extb.day.value == widget.text
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
