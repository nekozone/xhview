import 'dart:convert';
import 'package:XhView/tool/profile.dart';
import 'package:XhView/tool/status.dart';
import 'package:crypto/crypto.dart';

import '../network/connect.dart';
import '../core/getuserinfo.dart';

Future<bool> bbslogin(String username, String password) async {
  final bt = utf8.encode(password);
  final md5str = md5.convert(bt).toString();
  final res = await NetWorkRequest.login(username, md5str);
  print("Login code: ${res.code}");
  print("Login data: ${res.data}");
  if (res.code != 200) {
    return false;
  }
  final myinfo = MyInfo();
  final isok = await myinfo.get();
  print("Get info: ${isok}");
  if (!isok) {
    return false;
  }
  final info = myinfo.info;
  XhStatus.xhstatus.isLogin = true;
  UserProfiles.setLogin(true);
  UserProfiles.setUsername(username);
  UserProfiles.setPassword(md5str);
  await XhStatus.init();
  XhStatus.setUserInfo(info);
  return true;
}
