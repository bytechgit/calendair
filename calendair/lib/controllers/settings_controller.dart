import 'package:calendair/models/notification_settings_model.dart';

class SettingsController {
  Map<String, dynamic> notification = {
    "1": NotificationSettingsModel(
        "1",
        "Remind to complete unfinished assignments the day before the due date",
        'reminder'),
    "2": NotificationSettingsModel(
        "2", "Send inspirational quote to encourage studying", 'reminder'),
    "3": NotificationSettingsModel(
        "3", "Update on teacher announcements", 'updates'),
    "4": NotificationSettingsModel(
        "4", "Update on confidence meter popups", 'updates'),
    "5": NotificationSettingsModel(
        "5", "Update on TOS and app  development updates", 'updates'),
    "6": NotificationSettingsModel(
        "6", "Send when a new assignment is posted", 'assignments'),
    "7": NotificationSettingsModel(
        "7", "Send when a new exam is posted", 'assignments'),
    "8": NotificationSettingsModel(
        "8",
        "Send notification when assignment is done (via timer) ",
        'assignments'),
    "9": NotificationSettingsModel(
        "9",
        "Keep notification pinned with an ongoing assignment timer",
        'assignments'),
    "10": NotificationSettingsModel(
        "10", "Notify when teacher edits an assignment", 'assignments'),
  };
}
