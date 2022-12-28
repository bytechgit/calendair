import 'package:calendair/schedule/schedule_element.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentElement extends ScheduleElement {
  List<DateTime> dates;
  DateTime dueDate;
  List<int> indexes;
  List<String> materials;
  String note;
  List<int> remainingTimes;
  List<int> times;

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'duration': duration,
      'note': note,
      'indexes': indexes,
      "remainingTimes": remainingTimes,
      'dates': dates.map((e) => Timestamp.fromDate(e)).toList(),
      'times': times,
    };
  }

  AssignmentElement.fromMap(
      {required Map<String, dynamic> map,
      required String docId,
      DocumentChangeType? changeType})
      : dates = ((map["dates"] ?? []) as List<dynamic>)
            .map((e) => (e as Timestamp).toDate())
            .toList(),
        dueDate = (map["dueDate"] as Timestamp).toDate(),
        note = map["note"] ?? " ",
        times = ((map["times"] ?? []) as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        remainingTimes = ((map["remainingTimes"] ?? []) as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        indexes = ((map["indexes"] ?? []) as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        materials = ((map["materials"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        super.fromMap(map: map, docId: docId, changeType: changeType);
}
