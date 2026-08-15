import 'package:flutter/material.dart';

class BoardThemes {
  static const brownLight = Color(0xFFFFFFFF);
  static const brownDark = Color(0xFF6B4E45);

  static const blackWhiteLight = Color(0xFFFFFFFF);
  static const blackWhiteDark = Color(0xFF000000);

  static const blueWhiteLight = Color(0xFFFFFFFF);
  static const blueWhiteDark = Color(0xFF2B4FFF);

  static const brownModernLight = Color(0xFFDCC4A3);
  static const brownModernDark = Color(0xFF5B3A29);

  static Map<String, Map<String, Color>> themes = {
    'brown': {
      'light': brownLight,
      'dark': brownDark,
    },
    'black_white': {
      'light': blackWhiteLight,
      'dark': blackWhiteDark,
    },
    'blue_white': {
      'light': blueWhiteLight,
      'dark': blueWhiteDark,
    },
    'brown_modern': {
      'light': brownModernLight,
      'dark': brownModernDark,
    },
  };
}
