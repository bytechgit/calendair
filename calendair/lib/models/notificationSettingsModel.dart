import 'package:googleapis/mybusinessbusinessinformation/v1.dart';

class NotificationSettingsModel {
  String text;
  bool? checked;
  String? channel;
  NotificationSettingsModel(this.text, this.checked, this.channel);

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'checked': checked,
      'channel': channel,
    };
  }

  NotificationSettingsModel.fromMap(Map<String, dynamic> map)
      : text = map["text"] ?? " ",
        checked = map["checked"] ?? false,
        channel = map["channel"];
}
