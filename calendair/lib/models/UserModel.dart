import 'package:calendair/models/notificationSettingsModel.dart';

class UserModel {
  String id;
  String name;
  String picture;
  String type;
  int breakday;
  Map<String, dynamic> times;
  List<String> courses = [];
  List<NotificationSettingsModel> remindersNotification = [];
  List<NotificationSettingsModel> assignmentsNotification = [];
  List<NotificationSettingsModel> updatesNotification = [];

  UserModel(
      {required this.id,
      required this.name,
      required this.picture,
      required this.type,
      required this.courses,
      required this.breakday,
      required this.times});
  Map<String, dynamic> toMapStudent() {
    return {
      'name': name,
      'picture': picture,
      'courses': courses,
      "breakday": breakday,
      'type': type,
      'remindersNotification':
          remindersNotification.map((e) => e.toMap()).toList(),
      'assignmentsNotification':
          assignmentsNotification.map((e) => e.toMap()).toList(),
      'updatesNotification': updatesNotification.map((e) => e.toMap()).toList(),
    };
  }

  Map<String, dynamic> toMapTeacher() {
    return {
      'name': name,
      'picture': picture,
      'courses': courses,
      "breakday": breakday,
      'type': type,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map, String idDoc)
      : id = idDoc,
        name = map["name"] ?? " ",
        picture = map["picture"] ?? " ",
        type = map["type"] ?? " ",
        times = map["times"] ?? {},
        breakday = map["breakday"] ?? -1,
        courses = ((map["courses"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        remindersNotification =
            ((map["remindersNotification"] ?? []) as List<dynamic>)
                .map((e) => NotificationSettingsModel.fromMap(e))
                .toList(),
        assignmentsNotification =
            ((map["assignmentsNotification"] ?? []) as List<dynamic>)
                .map((e) => NotificationSettingsModel.fromMap(e))
                .toList(),
        updatesNotification =
            ((map["updatesNotification"] ?? []) as List<dynamic>)
                .map((e) => NotificationSettingsModel.fromMap(e))
                .toList();
}
