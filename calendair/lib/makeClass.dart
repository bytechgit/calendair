import 'package:calendair/generatingClassCode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottomNavBar.dart';
import 'models/nbar.dart';

class MakeClass extends StatefulWidget {
  const MakeClass({Key? key}) : super(key: key);

  @override
  State<MakeClass> createState() => _MakeClassState();
}

class _MakeClassState extends State<MakeClass> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      bottomNavigationBar: BottomNavBar(
        items: [
          NBar(
            slika: 'home',
          ),
        ],
        selected: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.7,
                child: const Text(
                  'What would you like to name your class?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 30),
                child: SizedBox(
                  width: width * 0.7,
                  //height: 40,
                  child: TextField(
                    maxLines: 3,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                        color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                      hintText: "Please Enter",
                      fillColor: const Color.fromRGBO(94, 159, 197, 1),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.8,
                child: const FittedBox(
                  child: Text(
                    'What period is this class in?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 30),
                child: SizedBox(
                  width: width * 0.7,
                  //height: 40,
                  child: TextField(
                    maxLines: 3,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                        color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                      hintText: "00",
                      fillColor: const Color.fromRGBO(94, 159, 197, 1),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.7,
                child: const Text(
                  'Choose the Google Classroom to sync to.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                child: SizedBox(
                  width: width * 0.7,
                  //height: 40,
                  child: TextField(
                    maxLines: 3,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                        color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                      hintText: "Select",
                      fillColor: const Color.fromRGBO(94, 159, 197, 1),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (() {
                  Get.to(
                    const GeneratingClassCode(),
                    transition: Transition.circularReveal,
                    duration: const Duration(milliseconds: 800),
                  );
                }),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: const Color.fromRGBO(94, 159, 197, 1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
