import 'package:calendair/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';

import 'bottomNavBar.dart';
import 'models/nbar.dart';

class PopUpsResults extends StatefulWidget {
  Course course;
  PopUpsResults({Key? key, required this.course}) : super(key: key);

  @override
  State<PopUpsResults> createState() => _PopUpsResultsState();
}

class _PopUpsResultsState extends State<PopUpsResults> {
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
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: width * 0.5,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.course.name ?? 'Period 1',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
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
            SizedBox(
              width: width * 0.8,
              child: Text(
                "Pop-Up Results",
                textAlign: TextAlign.center,
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
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Popups')
                      .where("ClassId", isEqualTo: widget.course.id)
                      .orderBy("order")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ...snapshot.data!.docs.reversed
                                .map(
                                  (d) => Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: SizedBox(
                                      width: width * 0.80,
                                      height: 90,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shadowColor: const Color.fromRGBO(
                                                247, 247, 247, 1),
                                            primary: const Color.fromRGBO(
                                                94, 159, 197, 1),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            )),
                                        onPressed: () {
                                          int a = (d['sumRate'] ?? 0) as int;
                                          int b = (d['numRate'] ?? 0) as int;
                                          Get.to(
                                            Results(rez: a / (b == 0 ? 1 : b)),
                                            transition:
                                                Transition.circularReveal,
                                            duration: const Duration(
                                                milliseconds: 800),
                                          );
                                        },

                                        child: FittedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FittedBox(
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'See ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            216, 218, 215, 1),
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      d["Date"] ?? '00/00/00',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            75, 77, 76, 1),
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      " " +
                                                          (d["Title"] ??
                                                              'Question '),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            75, 77, 76, 1),
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Text(
                                                      ' Results',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            216, 218, 215, 1),
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ), // <-- Text
                                      ),
                                    ),
                                  ),
                                )
                                .toList()
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
