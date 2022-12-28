class CourseModel {
  String docId;
  String classroomId;
  String classCode;
  String className;
  String creatorId;
  List<String> students;

  Map<String, dynamic> toMap() {
    return {
      'classroomId': classroomId,
      'classCode': classCode,
      'className': className,
      'creatorId': creatorId,
      "students": students
    };
  }

  CourseModel.fromMap(Map<String, dynamic> map, this.docId)
      : classCode = map["classCode"] ?? " ",
        classroomId = map["classroomId"] ?? " ",
        className = map["className"] ?? " ",
        creatorId = map["creatorId"] ?? " ",
        students = ((map["students"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
}
