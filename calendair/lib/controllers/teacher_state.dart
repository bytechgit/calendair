import 'package:calendair/models/popup_model.dart';
import 'package:calendair/models/remider_model.dart';
import 'package:flutter/material.dart';

class TeacherState with ChangeNotifier {
  Map<String, List<ReminderModel>> reminders = {};
  Map<String, List<PopUpModel>> popups = {};

  bool reminderExist(String classId) {
    if (reminders.containsKey(classId)) {
      return true;
    }
    return false;
  }

  bool popupsExist(String classId) {
    if (popups.containsKey(classId)) {
      return true;
    }
    return false;
  }

  void addPopUps(List<PopUpModel> popups, String classId) {
    this.popups[classId] = popups;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void addPopUp(PopUpModel popup, String classId) {
    popups[classId]?.add(popup);
    notifyListeners();
  }

  void addReminder(ReminderModel reminder, String classId) {
    reminders[classId]?.add(reminder);
    notifyListeners();
  }

  void addReminders(List<ReminderModel> reminders, String classId) {
    this.reminders[classId] = reminders;
    notifyListeners();
  }
}
