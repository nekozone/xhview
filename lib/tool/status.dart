import '../core/getindex.dart';
import '../core/getuserinfo.dart';

class XhStatus {
  static late BbsStatus xhstatus;
  static late bool isErr;
  // static late UserInfo userinfo;
  static init({bool getuserinfo = true}) async {
    xhstatus = BbsStatus();
    final res = await xhstatus.init(getuserinfo: getuserinfo);
    isErr = res;
    return res;
  }
}
