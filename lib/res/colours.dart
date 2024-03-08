import 'package:flutter/material.dart';

class Colours {
  static Color primaryColor = fromHex('#061D56');
  static Color buttonColor1 = fromHex('#FA5C49');
  static Color white = Colors.white;
  static Color white1 = fromHex("#E9EFF8");
  static Color buttonColor2 = fromHex("#0F0F26");
  static Color white3 = fromHex("#EFEFEF");
  static Color shadeColour = fromHex("#EEF3F6");
  static Color appbar = fromHex("#16272A");
  static Color black = Colors.black;
  static Color greyLight = Colors.grey.shade400;
  static Color greyLight700 = Colors.grey.shade700;
  static Color transparent = Colors.transparent;
  static Color gret500 = Colors.grey.shade500;
  static Color red900 = Colors.red.shade900;
  static Color tabText = fromHex("#0E1A1A");
  static Color listBackground = fromHex("#EEECFE");
  static Color titleBackground = fromHex("#5A918C");



  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
