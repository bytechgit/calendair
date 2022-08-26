import 'package:flutter/material.dart';

class ToDoCheck extends StatefulWidget {
  Color color;

  String number;
  String name;
  ToDoCheck(
      {Key? key, required this.color, required this.number, required this.name})
      : super(key: key);

  @override
  State<ToDoCheck> createState() => _ToDoCheckState();
}

class _ToDoCheckState extends State<ToDoCheck> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                  color: selected == false ? Colors.white : Colors.green),
              child: selected == true
                  ? const Icon(
                      Icons.done,
                      color: Colors.white,
                    )
                  : null,
            ),
            onTap: () {
              setState(() {
                selected = !selected;
              });
            },
          ),
          // Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              height: 20,
              width: width * 0.04,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: widget.color),
            ),
          ),
          // Expanded(child: Container()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      "${widget.number} Minutes",
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromRGBO(75, 76, 77, 1)),
                    ),
                  ),
                ],
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