class CourseModel {
  String docid;
  String courseId;
  String code;
  String name;
  String owner;
  List<String> students;

  Map<String, dynamic> toMap() {
    return {
      'id': courseId,
      'code': code,
      'name': name,
      'owner': owner,
      "students": students
    };
  }

  CourseModel.fromMap(Map<String, dynamic> map, String docId)
      : docid = docId,
        code = map["code"] ?? " ",
        courseId = map["id"] ?? " ",
        name = map["name"] ?? " ",
        owner = map["owner"] ?? " ",
        students = ((map["students"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
}
