import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

import '../teacher/popup_average_result.dart';

class RateClassStrength extends StatefulWidget {
  final String name;
  const RateClassStrength({super.key, required this.name});

  @override
  State<RateClassStrength> createState() => _RateClassStrengthState();
}

class _RateClassStrengthState extends State<RateClassStrength> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).popUntil((route) {
              print(route.settings.name);
              return route.settings.name == "/Navigation";
            });
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: const Color.fromRGBO(93, 159, 196, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 70.w,
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
                widget.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Container()),
            SizedBox(
              height: 70,
              width: 85.w,
              child: SfSliderTheme(
                data: SfSliderThemeData(
                  activeTrackHeight: 12,
                  inactiveTrackHeight: 12,
                ),
                child: SfSlider(
                  min: 0.0,
                  max: 100.0,
                  interval: 49,
                  showDividers: true,
                  value: value,
                  dividerShape: DividerShape(),
                  onChanged: (dynamic newValue) {
                    setState(() {
                      value = newValue;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              width: 70.w,
              child: const Padding(
                padding: EdgeInsets.only(top: 10),
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
                width: 50.w,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                      backgroundColor: const Color.fromRGBO(94, 159, 197, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) {
                      return route.settings.name == "/Navigation";
                    });
                  },

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
            Expanded(
              flex: 3,
              child: Container(),
            ),
          ]),
        ),
      ),
    );
  }
}
