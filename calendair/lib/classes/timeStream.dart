import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';

class TimeStream {
  static final TimeStream _singleton = TimeStream._internal();
  factory TimeStream() {
    return _singleton;
  }
  TimeStream._internal();

  final _stream = StreamController<int>.broadcast();

  void add(int n) {
    _stream.add(n);
  }

  Stream<int> get stream {
    return _stream.stream;
  }

  void pom() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      FlutterBackgroundService().invoke("addtime", {'time': timer.tick});
    });
  }
}
