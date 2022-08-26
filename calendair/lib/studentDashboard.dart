import 'package:flutter/material.dart';

class studentDashboard extends StatefulWidget {
  const studentDashboard({Key? key}) : super(key: key);

  @override
  State<studentDashboard> createState() => _studentDashboardState();
}

class _studentDashboardState extends State<studentDashboard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    bool selected = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Color.fromRGBO(93, 159, 196, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/calendar.png'),
            Image.asset('assets/images/home.png'),
            Image.asset('assets/images/settings.png'),
          ],
        ),
      ),
      body: SafeArea(
          child: SizedBox(
        child: selected == false
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                      child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SizedBox(
                        width: width * 0.7,
                        child: const FittedBox(
                          child: Text(
                            'Dashboard',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        width: width * 0.70,
                        height: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shadowColor:
                                  const Color.fromRGBO(247, 247, 247, 1),
                              primary: const Color.fromRGBO(94, 159, 197, 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          onPressed: () {},

                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: const Text(
                              'Classes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ), // <-- Text
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: width * 0.70,
                        height: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shadowColor:
                                  const Color.fromRGBO(247, 247, 247, 1),
                              primary: const Color.fromRGBO(94, 159, 197, 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          onPressed: () {},

                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: const Text(
                              'Extracurriculars',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ), // <-- Text
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: width * 0.70,
                        height: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shadowColor:
                                  const Color.fromRGBO(247, 247, 247, 1),
                              primary: const Color.fromRGBO(94, 159, 197, 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          onPressed: () {},

                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: const Text(
                              'Breakday',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ), // <-- Text
                        ),
                      ),
                    ),
                  ])),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: width * 0.9,
                      height: height * 0.8,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(26, 71, 97, 0.9),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Container()),
                                IconButton(
                                    onPressed: () {
                                      selected = true;
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                            FittedBox(
                              child: Text(
                                'Pop-Ups',
                                style: TextStyle(
                                    fontSize: 50,
                                    color: Color.fromRGBO(171, 223, 252, 1),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/triangle.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.55,
                                      child: const FittedBox(
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "00/00/00 Question",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
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
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SizedBox(
                    width: width * 0.7,
                    child: const FittedBox(
                      child: Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SizedBox(
                    width: width * 0.70,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      onPressed: () {},

                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: const Text(
                          'Classes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ), // <-- Text
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: width * 0.70,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      onPressed: () {},

                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: const Text(
                          'Extracurriculars',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ), // <-- Text
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: width * 0.70,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      onPressed: () {},

                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: const Text(
                          'Breakday',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ), // <-- Text
                    ),
                  ),
                ),
              ])),
        // ],
      )),
    );
  }
}
