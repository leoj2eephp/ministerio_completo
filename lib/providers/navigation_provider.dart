import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  static int _menu = 0;
  int get menu {
    return _menu;
  }

  set menu(int index) {
    _menu = index;
    notifyListeners();
  }
}
