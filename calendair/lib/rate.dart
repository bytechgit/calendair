import 'package:flutter/material.dart';

class rate extends StatefulWidget {
  const rate({Key? key}) : super(key: key);

  @override
  State<rate> createState() => _rateState();
}

class _rateState extends State<rate> {
  double _currentSliderValue = 20;
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
            onPressed: () {},
          ),
        ),
        bottomNavigationBar: Container(
          height: 60,
          color: Color.fromRGBO(93, 159, 196, 1),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: width * 0.7,
                    child: const Text(
                      "Rate your strength in this course",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 43),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Biology',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Slider(
                    value: _currentSliderValue,
                    max: 100,
                    divisions: 5,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    }),
                SizedBox(
                  width: width * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'This will allow us to create a personalized learning plan, perfect just for you!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: width * 0.5,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          primary: const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                      onPressed: () {},

                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // <-- Text
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ]),
            )));
  }
}
