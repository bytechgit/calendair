import 'package:flutter/material.dart';

class NavBarController with ChangeNotifier {
  int index = 0;
  void notify() {
    notifyListeners();
  }
}
