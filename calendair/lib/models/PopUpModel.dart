import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/cloudsearch/v1.dart';

class PopUpModel {
  String classId;
  Timestamp dueDate;
  String question;
  int numRate;
  double sumRate;
  String title;
  List<String> students;

  Map<String, dynamic> toMap() {
    return {
      'id': classId,
      'dueDate': dueDate,
      'question': question,
      'numRate': numRate,
      'sumRate': sumRate,
      'title': title,
      'students': students,
    };
  }

  PopUpModel.fromMap(Map<String, dynamic> map)
      : classId = map["id"] ?? " ",
        dueDate = map["dueDate"] ?? " ",
        question = map["question"] ?? " no question",
        numRate = map["numRate"] ?? " ",
        sumRate = (map["sumRate"] ?? 0).toDouble(),
        title = map["title"] ?? " ",
        students = ((map["students"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
}
