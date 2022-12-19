import 'package:cloud_firestore/cloud_firestore.dart';

class PopUpModel {
  String docId;
  String classId;
  Timestamp dueDate;
  String question;
  int numRate;
  double sumRate;
  String title;
  List<String> students;

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'dueDate': dueDate,
      'question': question,
      'numRate': numRate,
      'sumRate': sumRate,
      'title': title,
      'students': students,
    };
  }

  PopUpModel.fromMap(Map<String, dynamic> map, this.docId)
      : classId = map["classId"] ?? " ",
        dueDate = map["dueDate"] ?? " ",
        question = map["question"] ?? " no question",
        numRate = map["numRate"] ?? " ",
        sumRate = (map["sumRate"] ?? 0).toDouble(),
        title = map["title"] ?? " ",
        students = ((map["students"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
}
