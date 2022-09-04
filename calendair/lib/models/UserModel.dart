class UserModel {
  String id;
  String name;
  String picture;
  String type;
  String? breakday;
  List<String>? courses = [];

  UserModel(
      {required this.id,
      required this.name,
      required this.picture,
      required this.type,
      this.courses});
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'picture': picture,
      'courses': courses,
      'type': type,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map, String idDoc)
      : id = idDoc,
        name = map["name"] ?? " ",
        picture = map["picture"] ?? " ",
        type = map["type"] ?? " ",
        breakday = map["brekaday"],
        courses = ((map["courses"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
}
