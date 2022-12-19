class CustomCourse {
  String id;
  String docid;
  String code;
  String name;
  String owner;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'docid': docid,
      'code': code,
      'name': name,
      'owner': owner,
    };
  }

  CustomCourse.fromMap(Map<String, dynamic> map, String docId)
      : id = map["id"] ?? " ",
        docid = docId,
        code = map["code"] ?? " ",
        name = map["name"] ?? " ",
        owner = map["owner"] ?? " ";
}
