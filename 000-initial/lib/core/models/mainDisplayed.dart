import 'package:flutter/material.dart';

class MainDisplayed with ChangeNotifier {
  String _mainDisplayedData = "bpm";
  String get mainDisplayedData => _mainDisplayedData;

  set mainDisplayedData(String newValue) {
    _mainDisplayedData = newValue;
    //notifyListeners();
  }
}
