import 'package:calendair/controllers/timer.dart';
import 'package:calendair/schedule/schedule_element_assignment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class TodoStart extends StatefulWidget {
  final ScheduleElementAssignment element;
  const TodoStart({super.key, required this.element});

  @override
  State<TodoStart> createState() => _TodoStartState();
}

class _TodoStartState extends State<TodoStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SizedBox(
                width: 70.w,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.element.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
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
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(241, 188, 140, 1)),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Total: ${widget.element.duration} Minutes',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Row(children: [
                Expanded(child: Container()),
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.defaultDialog(
                        title: "Materials",
                        titleStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                        content: SizedBox(
                          height: 50.h,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: double.infinity,
                                ),
                                ...widget.element.assignmentRef.materials.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              child: Text(
                                                e,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                                iconSize: 30,
                                                onPressed: () async {
                                                  await launchUrl(Uri.parse(e),
                                                      mode: LaunchMode
                                                          .externalApplication);

                                                  Get.back();
                                                },
                                                icon: const Icon(
                                                    Icons.arrow_right)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: 60.w,
                    child: Text(
                      '${widget.element.title} PDF',
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
                width: 70.w,
                child: Text(
                  (widget.element).assignmentRef.note,
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
            const Spacer(),
            SizedBox(
              width: 75.w,
              height: 100,
              child: Consumer<Time>(builder: (_, time, __) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                      backgroundColor: const Color.fromRGBO(94, 159, 197, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  onPressed: () async {
                    if (widget.element.finished == false) {
                      time.start(widget.element);
                    }
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.element.finished
                          ? "Finished"
                          : (time.currentElement?.docId ==
                                      widget.element.docId &&
                                  time.currentElement?.positionIndex ==
                                      widget.element.positionIndex)
                              ? time.restTimeString
                              : "Start",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ), // <-- Text
                );
              }),
            ),
            const Spacer(),
          ]),
        ),
      ),
    );
  }
}
