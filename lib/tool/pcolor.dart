import 'package:flutter/material.dart';

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  // print(hexCode);
  return Color(int.parse('FF$hexCode', radix: 16));
}
