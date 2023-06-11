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
  if (res.code != 200) {
    return false;
  }
  final myinfo = MyInfo();
  final isok = await myinfo.get();
  if (!isok) {
    return false;
  }
  final info = myinfo.info;
  await XhStatus.init(getuserinfo: false);
  XhStatus.xhstatus.userinfo = info;
  // XhStatus.xhstatus.isLogin = true;
  UserProfiles.setUsername(username);
  UserProfiles.setPassword(md5str);
  return true;
}
