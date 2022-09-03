import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottomNavBar.dart';
import 'models/nbar.dart';

class Students extends StatefulWidget {
  const Students({Key? key}) : super(key: key);

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  bool selected = false;
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
      bottomNavigationBar: BottomNavBar(
        items: [
          NBar(
              slika: 'home',
              onclick: () {
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/TeacherDashboard');
              }),
        ],
        selected: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: SizedBox(
                    width: width * 0.7,
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Students',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Center(
                  child: SizedBox(
                    width: width * 0.8,
                    child: const Divider(
                      thickness: 10,
                      height: 15,
                      color: Color.fromRGBO(223, 223, 223, 1),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < 10; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selected = !selected;
                              });
                            },
                            child: Container(
                              height: 55,
                              width: width * 0.75,
                              decoration: BoxDecoration(
                                  color: selected == false
                                      ? const Color.fromRGBO(217, 217, 217, 1)
                                      : const Color.fromRGBO(159, 198, 220, 1),
                                  borderRadius: const BorderRadius.only(
                                      topRight: const Radius.circular(30),
                                      bottomRight: const Radius.circular(30))),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: width * 0.07,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(93, 159, 196, 1)),
                                    ),
                                    const Expanded(
                                      child: FittedBox(
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.scaleDown,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 20, left: 10),
                                          child: Text(
                                            'John',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 35,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
