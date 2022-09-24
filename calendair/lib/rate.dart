import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class Rate extends StatefulWidget {
  final bool back3;
  final String name;
  const Rate({Key? key, required this.name, this.back3 = true})
      : super(key: key);

  @override
  State<Rate> createState() => _RateState();
}

class _RateState extends State<Rate> {
  double _value = 0;
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
              if (widget.back3) {
                Get.close(3);
              } else {
                Get.back();
              }
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
                  width: width * 0.85,
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
                      value: _value,
                      dividerShape: DividerShape(),
                      onChanged: (dynamic newValue) {
                        setState(() {
                          _value = newValue;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.7,
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
                    width: width * 0.5,
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
                        if (widget.back3) {
                          Get.close(3);
                        } else {
                          Get.back();
                        }
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
            )));
  }
}

class DividerShape extends SfDividerShape {
  @override
  void paint(PaintingContext context, Offset center, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection}) {
    bool isActive;

    switch (textDirection) {
      case TextDirection.ltr:
        isActive = center.dx <= thumbCenter!.dx;
        break;
      case TextDirection.rtl:
        isActive = center.dx >= thumbCenter!.dx;
        break;
    }

    context.canvas.drawRect(
        Rect.fromCenter(center: center, width: 10.0, height: 40.0),
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..color = isActive
              ? themeData.activeTrackColor!
              : const Color.fromRGBO(202, 225, 239, 1));
  }
}
