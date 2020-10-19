import 'package:flutter/material.dart';

class MyMode with ChangeNotifier {
  bool _modeIsSimple = true;

  //MyMode.initial() : _modeIsSimple = true;

  bool get modeIsSimple => _modeIsSimple;

  set modeIsSimple(bool newValue) {
    _modeIsSimple = newValue;
    notifyListeners();
  }
}
