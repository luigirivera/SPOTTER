import 'package:flutter/material.dart';

class Data {
  static List<bool> _completed = List.filled(20, false);

  bool getCompletion(int index) {
    return _completed[index];
  }

  void setCompletion(int index, bool input) {
    _completed[index] = input;
  }
}
