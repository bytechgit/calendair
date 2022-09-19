import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      '----------------------------------------------------------------------------');
}

class FCMNotification {
  static final FCMNotification _instance = FCMNotification._internal();

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static String? _token;

  factory FCMNotification() {
    return _instance;
  }

  FCMNotification._internal() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _requestPermission();
    _loadFCM();
    _listenFCM();

    _getFCMToken().then((token) async {
      print(_token);
      await subscribeToTopic("545599618019_assignments");
      //sendDeviceMessage(token: _token, body: "body", title: "title");
      await sendTopicMessage(
          channel: "545599618019_assignments", title: "title", body: "body");
    });
  }

  static subscribeToTopic(String channel) async {
    await FirebaseMessaging.instance.subscribeToTopic(channel);
  }

  static unsubscribeFromTopic(String channel) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(channel);
  }

  void _listenFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          //foreground notification
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            //ovde hvata notifikacije u aplikaciji
            android: AndroidNotificationDetails(
              channel.id, channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'ic_launcher',
              playSound: true,
              //  sound: const RawResourceAndroidNotificationSound(
              //    'notification_sound'),
              enableLights: true,
              ledColor: const Color.fromARGB(255, 111, 153, 215),
              ledOnMs: 100,
              ledOffMs: 100,
              color: const Color.fromARGB(255, 111, 153, 215),
              colorized: true,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print("NEW TOKEN: " + fcmToken);
    }).onError((err) {
      // Error getting token.
    });
  }

  Future<void> _loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
          // sound: RawResourceAndroidNotificationSound('notification_sound'),
          showBadge: true,
          enableLights: true,
          ledColor: Colors.orange);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      //const AndroidInitializationSettings initializationSettingsAndroid =
      //  AndroidInitializationSettings('app_icon');

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the AndroidManifest.xml file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _getFCMToken() async {
    _token = await FirebaseMessaging.instance.getToken();
  }

  static Future<void> sendDeviceMessage(
      {String? token, String? body, String? title}) async {
    await _sendMessage(reciever: token, body: body, title: title);
  }

  static Future<void> sendTopicMessage(
      {String? channel, String? title, String? body}) async {
    await _sendMessage(reciever: '/topics/$channel', body: body, title: title);
  }

  /*static Future<void> _sendMessageV1(
      {String? reciever,
      String? body,
      String? title,
      required bool isTopic}) async {
    if (reciever == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      // print(await FirebaseAuth.instance.currentUser!.getIdToken());
      await http
          .post(
            Uri.parse(
                'https://fcm.googleapis.com/v1/projects/moj-majstor-a2658/messages:send'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ' +""
              
        
            },
            body: jsonEncode(<String, dynamic>{
              "message": {
                "notification": {
                  "title": " up 1.43% on the day",
                  "body":
                      'FooCorp gained 11.80 points to close at 835.67, up 1.43% on the day.'
                },
                "android": {
                  "notification": {
                    "icon": 'app_icon',
                    "color": '#7e55c3',
                    "image":
                        "https://lh3.googleusercontent.com/ogw/ADea4I5Z-pEWkfhAeASbHku2-CH_sG5H1QWZc36rvtUJ=s64-c-mo",
                    // "sound": "notification_sound",
                    //"light_on_duration": "1000",
                    //"light_off_duration": "1000",
                  }
                },
                isTopic ? "topic" : "to": reciever,
              }
            }),
          )
          .then((http.Response value) => print(value.body));
      print('FCM request for channel sent!');
    } catch (e) {
      print(e);
    }
  }*/

  static Future<void> _sendMessage(
      {String? reciever, String? body, String? title}) async {
    if (reciever == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      await http
          .post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
                  "key=AAAADx5i9Qw:APA91bGI262PcvZEDFHaiqdYmj1Hl3OBtDy4YNPOGURqXoZbzA1LWuS3RPd4Z_17wE_lbE1ZPXd3MjN6J1PxoO5jU0vc_cO0PMQTJWWFKaMf0II-znUVZ8dGclPu5R7i_qsA68BfJsan",
            },
            body: jsonEncode(<String, dynamic>{
              "notification": <String, dynamic>{
                "icon": "app_icon",
                "body": body ?? "No message",
                "title": title ??
                    "https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png",
                "image":
                    "https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"
              },
              'priority': 'high',
              // 'click_action': "FLUTTER_NOTIFICATION_CLICK",
              "data": <String, dynamic>{'id': '1', 'status': 'done'},
              "to": reciever //ovde se menja na id
            }),
          )
          .then((http.Response value) => print(value.body));

      print('FCM request for channel sent!');
    } catch (e) {
      print(e);
    }
  }
}
