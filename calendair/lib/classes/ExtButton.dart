import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExtButton extends GetxController {
  final day = "".obs;
  final index = 0.obs;
  ExtButton();
  DateTime getDay() {
    int d = DateTime.now().weekday - 1;
    int n = index.value - d;
    if (n < 0) {
      n += 7;
    }
    return DateTime.now().add(Duration(days: n));
  }

  final breakday = "".obs;
}
