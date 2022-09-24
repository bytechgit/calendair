import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notification =
      NotificationService._internal();
  NotificationService._internal();
  factory NotificationService() {
    return _notification;
  }
  final _localNotifications = FlutterLocalNotificationsPlugin();
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _localNotifications.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            icon: 'ic_launcher',
            ongoing: true,
            color: Color(0xff2196f3),
          ),
          iOS: DarwinNotificationDetails(
              categoryIdentifier: "plainCategory", threadIdentifier: "2"),
        ));
  }
}
