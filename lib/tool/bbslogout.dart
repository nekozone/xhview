import '../network/connect.dart';
import '../tool/status.dart';

Future<bool> bbslogout(String url) async {
  final res = await NetWorkRequest.getHtml(url);
  if (res.code != 200) {
    return false;
  }
  await XhStatus.init(getuserinfo: true);
  return true;
}
