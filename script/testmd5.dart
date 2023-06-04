import 'dart:convert';
import 'package:crypto/crypto.dart';

const String rawStr = "忽有狂徒夜磨刀，帝星飘摇荧惑高。";

void main(List<String> args) {
  final bt = utf8.encode(rawStr);
  final md5str = md5.convert(bt);
  print(md5str.toString());
}
