import '../network/connect.dart';
import 'package:html/parser.dart';

class UserspaceInfo {
  final int uid;
  UserspaceInfo({required this.uid});
  late String username;
  late String avatar;
  late Map<String, String> spaceinfo;
  late String? logouturl;
  bool status = true;

  Future<bool> getinfo() async {
    final res = await NetWorkRequest.getHtml(
        "https://bbs.dippstar.com/home.php?mod=space&uid=$uid&do=profile&mobile=2");

    if (res.code != 200) {
      status = false;
      return false;
    }

    final document = parse(res.data);

    // 获取参数表

    final Map<String, String> infomap = {};
    final ulele = document.getElementsByTagName("ul");
    if (ulele.isEmpty) {
      spaceinfo = infomap;
    } else {
      final ul = ulele[0];
      final lisele = ul.getElementsByTagName("li");
      for (var liele in lisele) {
        final valuele = liele.getElementsByTagName("span")[0];
        final value = valuele.text;
        valuele.remove();
        final key = liele.text;
        infomap[key] = value;
      }
      spaceinfo = infomap;
    }
  }
}
