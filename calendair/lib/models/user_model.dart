class UserModel {
  String uid;
  String name;
  String picture;
  String type;
  int breakday = 2;
  List<int> extracurricularsTimes = [];
  Map<String, int> times = {};
  Map<String, bool> notifications = {};
  List<String> courses = [];
  UserModel({
    required this.uid,
    required this.name,
    required this.picture,
    required this.type,
    required this.breakday,
  });

  Map<String, dynamic> toMapStudent() {
    return {
      'name': name,
      'picture': picture,
      'courses': courses,
      "breakday": breakday,
      'type': type,
      'times': times,
      'extracurricularsTimes': extracurricularsTimes,
      'notifications': notifications
    };
  }

  Map<String, dynamic> toMapTeacher() {
    return {
      'name': name,
      'picture': picture,
      'courses': courses,
      'type': type,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map, String idDoc)
      : uid = idDoc,
        name = map["name"] ?? " ",
        picture = map["picture"] ?? " ",
        type = map["type"] ?? " ",
        times = Map.from(map["times"] ?? {}),
        notifications = Map.from(map["notifications"] ?? {}),
        breakday = map["breakday"] ?? -1,
        courses = ((map["courses"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        extracurricularsTimes =
            ((map["extracurricularsTimes"] ?? []) as List<dynamic>)
                .map((e) => e as int)
                .toList();
  // remindersNotification =
  //     ((map["remindersNotification"] ?? []) as List<dynamic>)
  //         .map((e) => NotificationSettingsModel.fromMap(e))
  //         .toList(),
  // extracurricularsTimes =
  //     ((map["extracurricularsTimes"] ?? []) as List<dynamic>)
  //         .map((e) => e)
  //         .toList(),
  // assignmentsNotification =
  //     ((map["assignmentsNotification"] ?? []) as List<dynamic>)
  //         .map((e) => NotificationSettingsModel.fromMap(e))
  //         .toList(),
  // updatesNotification =
  //     ((map["updatesNotification"] ?? []) as List<dynamic>)
  //         .map((e) => NotificationSettingsModel.fromMap(e))
  //         .toList();
}
