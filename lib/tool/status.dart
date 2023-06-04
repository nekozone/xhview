import 'package:flutter/gestures.dart';

import '../core/getindex.dart';
import '../core/getuserinfo.dart';

class XhStatus {
  static late BbsStatus xhstatus;
  static late bool isErr;
  static late UserInfo userinfo;
  static init() async {
    xhstatus = BbsStatus();
    final res = await xhstatus.init();
    isErr = res;
    return res;
  }

  static setUserInfo(UserInfo info) {
    userinfo = info;
  }
}
