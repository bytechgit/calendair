import 'package:cloud_firestore/cloud_firestore.dart';

class PopUpModel {
  String docId;
  String courseId;
  Timestamp dueDate;
  Timestamp createdAt;
  String question;
  int numRate;
  double sumRate;
  String title;
  List<String> students;

  PopUpModel(
      {this.docId = "",
      required this.courseId,
      required this.dueDate,
      required this.createdAt,
      required this.question,
      required this.numRate,
      required this.sumRate,
      required this.title,
      required this.students});

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'dueDate': dueDate,
      'question': question,
      'numRate': numRate,
      'sumRate': sumRate,
      'title': title,
      'students': students,
      'createdAt': createdAt,
    };
  }

  PopUpModel.fromMap(Map<String, dynamic> map, this.docId)
      : courseId = map["courseId"] ?? " ",
        dueDate = map["dueDate"],
        createdAt = map["createdAt"],
        question = map["question"] ?? " no question",
        numRate = map["numRate"] ?? " ",
        sumRate = (map["sumRate"] ?? 0).toDouble(),
        title = map["title"] ?? " ",
        students = ((map["students"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
}
