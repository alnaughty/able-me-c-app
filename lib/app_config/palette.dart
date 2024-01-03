// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';

mixin class ColorPalette {
  MaterialColor greenPalette = const MaterialColor(
    0xFF75B13F,
    <int, Color>{
      50: Color(0xffbad89f),
      100: Color(0xffacd08b),
      200: Color(0xff9ec878),
      300: Color(0xff90c065),
      400: Color(0xff82b852),
      500: Color(0xFF75B13F),
      600: Color(0xff699f38),
      700: Color(0xff5d8d32),
      800: Color(0xff517b2c),
      900: Color(0xff466a25),
    },
  );

  final Color blue = const Color(0xff3E74B1);
  final Color orange = const Color(0xffF8C624);
  final Color grey = const Color(0xffBDC3C7);
}
