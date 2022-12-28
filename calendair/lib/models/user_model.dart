class UserModel {
  String uid;
  String name;
  String picture;
  String type;
  int breakday = -1;
  Map<String, bool> notifications = {};
  List<String> courses = [];
  UserModel({
    required this.uid,
    required this.name,
    required this.picture,
    required this.type,
    this.breakday = -1,
  });

  Map<String, dynamic> toMapStudent() {
    return {
      'name': name,
      'picture': picture,
      'courses': courses,
      "breakday": breakday,
      'type': type,
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
        notifications = Map.from(map["notifications"] ?? {}),
        breakday = map["breakday"] ?? -1,
        courses = ((map["courses"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
}
