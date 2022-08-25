import 'package:calendair/registerWhatUser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../loginRegister.dart';

class InputClassCode extends StatefulWidget {
  const InputClassCode({Key? key}) : super(key: key);

  @override
  State<InputClassCode> createState() => _InputClassCodeState();
}

class _InputClassCodeState extends State<InputClassCode> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromRGBO(247, 247, 247, 1),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/registerTop.png'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/images/registerBottom.png'),
            ),
            ///////images
            ///
            ///
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (() {
                          Get.to(
                            const LoginRegister(),
                            transition: Transition.circularReveal,
                            duration: const Duration(milliseconds: 800),
                          );
                        }),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(247, 247, 247, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13))),
                          width: width * 0.35,
                          height: 40,
                          child: const Center(
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (() {
                          Get.to(
                            const RegisterWhatUser(),
                            transition: Transition.circularReveal,
                            duration: const Duration(milliseconds: 800),
                          );
                        }),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(198, 218, 229, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(13),
                            ),
                          ),
                          width: width * 0.35,
                          height: 40,
                          child: const Center(
                              child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 6,
                    width: width * 0.7,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(94, 159, 196, 1),
                        borderRadius: BorderRadius.all(Radius.circular(13))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SizedBox(
                      width: width * 0.7,
                      child: const FittedBox(
                        child: Text(
                          "Please Input Your Class Code",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.7,
                    //height: 40,
                    child: TextField(
                      style: const TextStyle(
                          color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                        hintText: "000-000",
                        fillColor: const Color.fromRGBO(94, 159, 197, 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SizedBox(
                      width: width * 0.7,
                      child: Column(
                        children: const [
                          Text(
                            "You should recieve",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(123, 123, 123, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Text(
                            "the code from your teacher!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(123, 123, 123, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
