import 'dart:async';

import 'package:calendair/schedule/schedule_element_assignment.dart';
import 'package:flutter/material.dart';

class Time extends ChangeNotifier {
  Timer? timer;
  ScheduleElementAssignment? currentElement;
  DateTime? startTime;
  void start(ScheduleElementAssignment element) {
    if (element == currentElement) {
      //stop
      element.updateRemainingTime(restTime < 0 ? 0 : restTime);
      currentElement = null;
      startTime = null;
      timer?.cancel();
    } else if (currentElement == null) {
      //start
      currentElement = element;
      startTime = DateTime.now();
      startTimer();
    } else {
      //stop
      //start
      currentElement!.updateRemainingTime(restTime < 0 ? 0 : restTime);
      currentElement = element;
      startTime = DateTime.now();
      startTimer();
    }
    notifyListeners();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      notifyListeners();
      if (restTime <= 0) {
        currentElement?.finish(true);
        timer.cancel();
      }
    });
  }

  int get restTime {
    return currentElement!.remainingTime -
        DateTime.now().difference(startTime!).inSeconds;
  }

  String get restTimeString {
    final time = restTime < 0 ? 0 : restTime;
    return "${(time ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}";
  }
}
