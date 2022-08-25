import 'package:flutter/material.dart';

class RegisterTeacher extends StatefulWidget {
  const RegisterTeacher({Key? key}) : super(key: key);

  @override
  State<RegisterTeacher> createState() => _RegisterTeacher();
}

class _RegisterTeacher extends State<RegisterTeacher> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(247, 247, 247, 1),
        child: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset('assets/images/backgroundTop.png'),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset('assets/images/backgroundBottom.png'),
          ),
          ///////images
          ///
          ///
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SizedBox(
                    width: width * 0.7,
                    height: 60,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                      onPressed: () {},

                      icon: Image.asset(
                        'assets/images/google.png',
                        width: 24,
                      ),
                      label: const Text(
                        'Sign in with Google',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ), // <-- Text
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SizedBox(
                    width: width * 0.55,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                      onPressed: () {},

                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // <-- Text
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
