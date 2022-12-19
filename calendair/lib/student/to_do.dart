import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ToDo extends StatefulWidget {
  final bool fromCalendar;
  final String day;
  final int index;
  const ToDo(
      {Key? key,
      required this.day,
      required this.index,
      this.fromCalendar = false})
      : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  //late final ScheduleController scheduleController;
  @override
  void initState() {
    // scheduleController = context.read<ScheduleController>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

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
          child: SizedBox(
            width: width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SizedBox(
                    width: width * 0.65,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.day,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.67,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      DateFormat("MMMM dd").format(DateTime.now().subtract(
                          Duration(
                              days:
                                  DateTime.now().weekday - 1 - widget.index))),
                      style: const TextStyle(
                        color: Color.fromRGBO(93, 159, 196, 1),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // ...scheduleController.scheduleElements[widget.index]
                        //     .map((el) {
                        //   if (el is ScheduleElementAssignment) {
                        //     return ToDoCheck(el: el);
                        //   } else {
                        //     return const SizedBox.shrink();
                        //   }
                        // }).toList(),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: width * 0.6,
                          child: const Text(
                            "\"It always seems impossible until it's done.\"",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.5,
                          child: const FittedBox(
                              child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              '-Nelson Mandela',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.58),
                                fontSize: 18,
                              ),
                            ),
                          )),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
