import 'package:calendair/student/to_dos.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sizer/sizer.dart';
import 'calendar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          height: 30,
                        ),
                        for (int i = 0; i < days.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 0),
                            child: InkWell(
                              onTap: (() {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: ToDos(
                                    index: i,
                                    day: days[i],
                                  ),
                                  withNavBar: true,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.fade,
                                );
                              }),
                              child: SizedBox(
                                height: 60,
                                width: 80.w,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: FittedBox(
                                        child: Text(
                                          days[i],
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(93, 159, 196, 1),
                                            fontSize: 50,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: const Offset(0, -3),
                                      child: const Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Divider(
                                          thickness: 10,
                                          color: Color.fromRGBO(0, 0, 0, 0.1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: const Calendar(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text(
                      'See Week',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
