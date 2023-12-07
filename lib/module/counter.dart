import 'package:flutter/material.dart';

class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    debugPrint("decrement");

    _count++;
    notifyListeners();
  }

  void decrement() {
    debugPrint("decrement");
    _count--;
    notifyListeners();
  }
}
