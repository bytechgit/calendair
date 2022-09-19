class Notification {
  String id;
  String title;
  int time;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
    };
  }

  Notification.fromMap(Map<String, dynamic> map)
      : id = map["id"] ?? " ",
        title = map["title"] ?? " ",
        time = map["time"] ?? 0;
}
