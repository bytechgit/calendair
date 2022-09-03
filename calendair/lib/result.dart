import 'package:calendair/popUpsConfidenceMeter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class Results extends StatefulWidget {
  double rez;
  Results({Key? key, required this.rez}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  double _value = 21.0;
  @override
  Widget build(BuildContext context) {
    print(widget.rez);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () async {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 5),
              child: SizedBox(
                width: width * 0.70,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                      primary: const Color.fromRGBO(94, 159, 197, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  onPressed: () {},

                  child: const Text(
                    'Results',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // <-- Text
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/resultsSad.png',
                  width: width * 0.18,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      child: FittedBox(
                        child: Text(
                          'Average Class Answer: ${widget.rez.toPrecision(2)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: width * 0.5,
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
                          value: widget.rez,
                          dividerShape: DividerShape(),
                          onChanged: (dynamic newValue) {
                            // setState(() {
                            //   _value = newValue;
                            // });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/resultsHappy.png',
                  width: width * 0.165,
                ),
              ],
            )
          ],
        ),
      )),
    );
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
              : Color.fromRGBO(202, 225, 239, 1));
  }
}
