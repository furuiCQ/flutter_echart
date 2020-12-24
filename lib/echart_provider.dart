import 'package:flutter/material.dart';

class CounterProvider with ChangeNotifier {
  Key key;
  Map data;

  Map get value => data;

  Key get keyCount => key;

  void refresh(Key key, Map data) {
    this.key = key;
    this.data = data;
    notifyListeners();
  }
}
