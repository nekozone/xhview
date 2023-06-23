import 'package:flutter/material.dart';

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  // print(hexCode);
  try {
    return Color(int.parse('FF$hexCode', radix: 16));
  } catch (e) {
    return Colors.black;
  }
}
