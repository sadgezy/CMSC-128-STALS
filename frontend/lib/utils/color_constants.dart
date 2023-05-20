import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color black9007f = fromHex('#7f000000');

  static Color blueGray100 = fromHex('#d9d9d9');

  static Color black900 = fromHex('#000000');

  static Color gray900 = fromHex('#1f2421');

  static Color cyan900 = fromHex('#19535f');

  static Color black9003f = fromHex('#3f000000');

  static Color whiteA700 = fromHex('#ffffff');

  static Color gray100 = fromHex('#f0f3f5');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
