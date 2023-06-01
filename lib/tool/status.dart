import '../core/getindex.dart';

class XhStatus {
  static late BbsStatus xhstatus;
  static late bool isErr;
  static init() async {
    xhstatus = BbsStatus();
    final res = await xhstatus.init();
    isErr = res;
    return res;
  }
}
