import 'dart:async';
import 'package:calendair/models/schedule/scheduleElementAssignment.dart';
import 'package:get/get.dart';

import 'notification.dart';

class TimerAssignment extends GetxController {
  final sea = Rx<ScheduleElementAssignment?>(null);
  Timer? t;
  final time = 'Start'.obs;
  void start(ScheduleElementAssignment a) {
    if (a == sea.value) {
      a.finish(false, time: a.timesec);
      t?.cancel();
      sea.value = null;
      time.value = 'Start';
    } else {
      if (sea.value != null) {
        Get.snackbar(sea.value!.title_, 'Please finish this assigment first');
        return;
      }
      sea.value = a;
      if (a.timesec == 0) {
        sea.value = null;
        return;
      }
      if (t != null) {
        t!.cancel();
      }
      t = Timer.periodic(const Duration(seconds: 1), (timer) async {
        a.timesec--;
        time.value =
            '${(a.timesec / 60).floor().toString().padLeft(2, '0')}:${(a.timesec % 60).toString().padLeft(2, '0')}';
        // NotificationService().showLocalNotification(id: 888, title: a.title_, body: time.value);
        if (a.timesec == 0) {
          time.value = 'Time\'s up';
          // if (Firestore()
          //         .firebaseUser!
          //         .assignmentsNotification
          //         .firstWhereOrNull(
          //             (element) => element.channel == "assignmentFinished")
          //         ?.checked ??
          //     false) {
          //   NotificationService().showLocalNotification(
          //       id: 888, title: a.title_, body: time.value);
          // }
          //TODO:treba da se otkomentarise
          a.finish(true, time: 0);
          timer.cancel();
        }
      });
    }
  }
}
