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

  // 🟣 الثيم الأرجواني (تصميم الماكيت الجديد)
  static const purpleLight = Color(0xFFEFE9F4);
  static const purpleDark = Color(0xFFB08BBF);

  static Map<String, Map<String, Color>> themes = {
    'purple': {
      'light': purpleLight,
      'dark': purpleDark,
    },
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

/// 🎨 ألوان واجهة اللعبة (تصميم الماكيت)
class GameUiColors {
  static const scaffoldBg = Color(0xFFF4F1F6);
  static const pillFill = Color(0xFFEFE8F2);
  static const primaryPurple = Color(0xFFAB86B9);
  static const selectedSquare = Color(0xFF9E7BB5);
  static const moveDot = Color(0xFFE9E2F0);
  static const darkText = Color(0xFF3D3654);
  static const avatarBlue = Color(0xFF5AB9EA);
}
