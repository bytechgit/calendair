import 'package:calendair/assignmentsUpdate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottomNavBar.dart';
import 'models/nbar.dart';

class Assignments extends StatefulWidget {
  const Assignments({Key? key}) : super(key: key);

  @override
  State<Assignments> createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
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
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: width * 0.5,
                  child: const FittedBox(
                    child: Text(
                      'Period 1',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.8,
                child: const Divider(
                  thickness: 10,
                  height: 15,
                  color: Color.fromRGBO(223, 223, 223, 1),
                ),
              ),
              const FittedBox(
                child: Text(
                  "Assignments",
                  style: TextStyle(
                    color: Color.fromRGBO(93, 159, 196, 1),
                    fontSize: 50,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < 10; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 80,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(243, 162, 162, 1),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.55,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      FittedBox(
                                        child: Text(
                                          "Genetics Lab",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          "85 Minutes",
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                143, 146, 145, 1),
                                            fontSize: 30,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                IconButton(
                                    iconSize: 55,
                                    onPressed: () {
                                      Get.to(
                                        const AssignmentsUpdate(),
                                        transition: Transition.circularReveal,
                                        duration:
                                            const Duration(milliseconds: 800),
                                      );
                                    },
                                    icon: const Icon(Icons.settings))
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
