import 'package:calendair/models/ScheduleElementModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DayToDo extends StatefulWidget {
  final ScheduleElement sc;
  const DayToDo({Key? key, required this.sc}) : super(key: key);

  @override
  State<DayToDo> createState() => _DayToDoState();
}

class _DayToDoState extends State<DayToDo> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SafeArea(
            child: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SizedBox(
                width: width * 0.7,
                child: FittedBox(
                  child: Text(
                    widget.sc.title_,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    width: width * 0.04,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(241, 188, 140, 1)),
                  ),
                  FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Total: ${widget.sc.time} Minutes',
                        style: const TextStyle(
                            fontSize: 30,
                            color: Color.fromRGBO(75, 76, 77, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 10,
                  color: Color.fromRGBO(93, 159, 196, 1),
                ),
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                Expanded(child: Container()),
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Divider(
                          thickness: 5,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Divider(
                          thickness: 5,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Divider(
                          thickness: 5,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: width * 0.6,
                    child: Text(
                      '${widget.sc.title_} PDF',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ]),
            ),
            Expanded(child: Container()),
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Divider(
                  thickness: 10,
                  color: Color.fromRGBO(93, 159, 196, 0.25),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: SizedBox(
                width: width * 0.7,
                child: Text(
                  (widget.sc as ScheduleElementAssignment).note,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Divider(
                  thickness: 10,
                  color: Color.fromRGBO(93, 159, 196, 0.25),
                ),
              ),
            ),
            Expanded(child: Container()),
            SizedBox(
              width: width * 0.75,
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                    primary: const Color.fromRGBO(94, 159, 197, 1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                onPressed: () {},

                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Start',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), // <-- Text
              ),
            ),
            Expanded(child: Container()),
          ]),
        )));
  }
}
