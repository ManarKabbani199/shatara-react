import 'package:flutter/material.dart';

class BoardThemes {
  static const blackWhiteLight = Color(0xFFFFFFFF);
  static const blackWhiteDark = Color(0xFF000000);

  static const blueWhiteLight = Color(0xFFFFFFFF);
  static const blueWhiteDark = Color(0xFF2B4FFF);

  // 🟣 الثيم الأرجواني (تصميم الماكيت الجديد): أبيض + أرجواني الموقع
  static const purpleLight = Color(0xFFFFFFFF);
  static const purpleDark = Color(0xFFAB86B9);

  static Map<String, Map<String, Color>> themes = {
    'purple': {
      'light': purpleLight,
      'dark': purpleDark,
    },
    'black_white': {
      'light': blackWhiteLight,
      'dark': blackWhiteDark,
    },
    'blue_white': {
      'light': blueWhiteLight,
      'dark': blueWhiteDark,
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
