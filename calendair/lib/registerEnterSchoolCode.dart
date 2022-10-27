import 'package:calendair/registerGoogle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterEnterSchoolCode extends StatefulWidget {
  const RegisterEnterSchoolCode({Key? key}) : super(key: key);

  @override
  State<RegisterEnterSchoolCode> createState() =>
      _RegisterEnterSchoolCodeState();
}

class _RegisterEnterSchoolCodeState extends State<RegisterEnterSchoolCode> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromRGBO(247, 247, 247, 1),
        child: Stack(children: [
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ),
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
                    "Register",
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
                          borderRadius: BorderRadius.all(Radius.circular(13))),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.7,
                    child: const FittedBox(
                      child: Text(
                        "Enter Your School Code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: SizedBox(
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
                        "Each school is given a unique code!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(123, 123, 123, 1),
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.35,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                      onPressed: () {
                        Get.to(
                          const RegisterGoogle(),
                          transition: Transition.circularReveal,
                          duration: const Duration(milliseconds: 800),
                        );
                      },

                      child: const Text(
                        'Enter',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // <-- Text
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
