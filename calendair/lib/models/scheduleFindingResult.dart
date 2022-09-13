import 'package:calendair/models/ScheduleElementModel.dart';

class FindingResult {
  late int dayId;
  late int classId;
  late ScheduleElement element;

  FindingResult(this.dayId, this.classId, this.element);
}
