class NotificationSettingsModel {
  String text;
  bool checked = false;
  String id;
  String? channel;
  String type;
  NotificationSettingsModel(this.id, this.text, this.type);

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'checked': checked,
      'channel': channel,
    };
  }
}
