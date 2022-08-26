import 'package:flutter/material.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      //const Color.fromRGBO(93, 159, 196, 1),

      bottomNavigationBar: Container(
        height: 60,
        color: Color.fromRGBO(93, 159, 196, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/calendarRounded.png'),
            Image.asset(
              'assets/images/home1.png',
              scale: 1.7,
            ),
            Image.asset('assets/images/settings.png'),
          ],
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                color: Color.fromRGBO(93, 159, 196, 1),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 55, 20, 0),
                  child: Container(
                    width: 100,
                    child: Center(
                      child: Text(
                        'See Week',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3),
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 0),
                    child: InkWell(
                      onTap: (() {}),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Monday",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: InkWell(
                      onTap: (() {}),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Tuesday",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: InkWell(
                      onTap: (() {}),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Tuesday",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: InkWell(
                      onTap: (() {}),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Tuesday",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: InkWell(
                      onTap: (() {}),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Wednesday",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: InkWell(
                      onTap: (() {}),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Thursday",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: InkWell(
                      onTap: (() {}),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Friday",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: InkWell(
                      onTap: (() {}),
                      child: SizedBox(
                        height: 60,
                        width: width * 0.8,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  "Saturday",
                                  style: TextStyle(
                                    color: Color.fromRGBO(93, 159, 196, 1),
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
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 20, top: 20),
                  //   child: InkWell(
                  //     onTap: (() {}),
                  //     child: SizedBox(
                  //       height: 60,
                  //       width: width * 0.8,
                  //       child: Stack(
                  //         children: [
                  //           const Align(
                  //             alignment: Alignment.topLeft,
                  //             child: FittedBox(
                  //               child: Text(
                  //                 "Sunday",
                  //                 style: TextStyle(
                  //                   color: Color.fromRGBO(93, 159, 196, 1),
                  //                   fontSize: 50,
                  //                   fontWeight: FontWeight.w500,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Transform.translate(
                  //             offset: const Offset(0, -3),
                  //             child: const Align(
                  //               alignment: Alignment.bottomLeft,
                  //               child: Divider(
                  //                 thickness: 10,
                  //                 color: Color.fromRGBO(0, 0, 0, 0.1),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
