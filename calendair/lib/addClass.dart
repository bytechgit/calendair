import 'package:calendair/joinNotification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Classes/googleClassroom.dart';

class addClass extends StatefulWidget {
  const addClass({Key? key}) : super(key: key);

  @override
  State<addClass> createState() => _addClassState();
}

class _addClassState extends State<addClass> {
  final gc = Get.find<GoogleClassroom>();
  final codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromRGBO(247, 247, 247, 1),
          child: Stack(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Get.back();
                    },
                  )),
            ),
            IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset('assets/images/backgroundTop.png'),
              ),
            ),
            IgnorePointer(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/backgroundBottom.png'),
              ),
            ),
            ///////images
            ///
            ///
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Insert Class Code",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        height: 6,
                        width: width * 0.7,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(94, 159, 196, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(13))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: SizedBox(
                        width: width * 0.7,
                        //height: 40,
                        child: TextField(
                          controller: codeController,
                          style: const TextStyle(
                              color: Color.fromRGBO(38, 64, 78, 1),
                              fontSize: 25),
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(38, 64, 78, 1),
                                fontSize: 25),
                            hintText: "000-000",
                            fillColor: const Color.fromRGBO(94, 159, 197, 1),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SizedBox(
                        width: width * 0.5,
                        child: const Text(
                          "This code will be given by your teacher!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(123, 123, 123, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: const CircleBorder(),
                        ),
                        onPressed: () async {
                          String name =
                              await gc.enrolToCourse(codeController.text);
                          if (name != "" && name != "Error") {
                            Get.to(
                              joinNotification(name: name),
                              transition: Transition.circularReveal,
                              duration: const Duration(milliseconds: 800),
                            );
                          }
                        },

                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                        ), // <-- Text
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
