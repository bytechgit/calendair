import 'package:calendair/controllers/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

class ConfidenceMeter extends StatefulWidget {
  final String id;
  final String message;
  final String question;

  const ConfidenceMeter(
      {Key? key,
      required this.id,
      required this.message,
      required this.question})
      : super(key: key);

  @override
  State<ConfidenceMeter> createState() => _ConfidenceMeterState();
}

class _ConfidenceMeterState extends State<ConfidenceMeter> {
  late FirebaseController firebaseController;
  @override
  void initState() {
    firebaseController = context.read<FirebaseController>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
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

  double _value = 0.0;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.question,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromRGBO(94, 159, 197, 1),
                  ),
                  width: width * 0.70,
                  height: 55,
                  child: const Center(
                    child: Text(
                      'Confidence Meter',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                        //width: width * 0.55,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            " ${widget.message} ",
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
                              inactiveTrackColor:
                                  const Color.fromARGB(255, 147, 192, 220)),
                          child: SfSlider(
                            min: 0.0,
                            max: 100.0,
                            interval: 50,
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
                    ],
                  ),
                  Image.asset(
                    'assets/images/resultsHappy.png',
                    width: width * 0.165,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      onPressed: () {
                        firebaseController.addPopUpRate(
                            widget.id, _value.round());
                        Get.back();
                      },
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Submit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ), // <-- Text
                    ),
                  ),
                ),
              ),
            ],
          ),
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
              : const Color.fromARGB(255, 147, 192, 220));
  }
}
