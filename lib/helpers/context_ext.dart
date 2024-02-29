import 'package:flutter/material.dart';

extension CONT on BuildContext {
  TextTheme get fontTheme => Theme.of(this).textTheme;
  Size? get csize => MediaQuery.of(this).size;
  ThemeData get theme => Theme.of(this);
  bool get isDarkMode {
    var brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}
