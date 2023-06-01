import '../network/connect.dart';
import 'package:html/parser.dart';

class BbsStatusInfo {
  late int notenum;
  late int people;
  late int online;
}

class Dist {
  late String title;
  late int id;
}

class BigDist {
  late String title;
  late List<Dist> dists;
}

class BbsStatus {
  late BbsStatusInfo info;
  late List<BigDist> bigdists;
  late bool isLogin = false;
  init() async {
    info = BbsStatusInfo();
    bigdists = [];
    final resdata = await getHtml(
        "https://bbs.dippstar.com/forum.php?forumlist=1&mobile=no&mobile=1&simpletype=no");
    if (resdata.code != 200) {
      return false;
    }
    final document = parse(resdata.data);
    final loginElement = document.getElementsByClassName("pd2");
    if (loginElement.isEmpty) {
      isLogin = false;
    } else {
      isLogin = !(loginElement[0].getElementsByTagName('a')[0].text == "登录");
    }
    final elements = document.getElementsByClassName("box");
    if (elements.isEmpty) {
      return false;
    }
    var rawstr = elements[0].text;
    var restr = RegExp(r"(\d+)");
    var match = restr.allMatches(rawstr);
    info.notenum = int.parse(match.elementAt(0).group(0)!);
    info.people = int.parse(match.elementAt(1).group(0)!);
    info.online = int.parse(match.elementAt(2).group(0)!);
    final elements2 = document.getElementsByClassName("bm");
    if (elements2.isEmpty) {
      return false;
    }
    for (var element in elements2) {
      final bigdist = BigDist();
      bigdist.dists = [];
      final tit = element.getElementsByClassName("bm_h");
      if (tit.isEmpty) {
        return false;
      }
      bigdist.title = tit[0].text;
      final items = element.getElementsByClassName("bm_c");
      for (var item in items) {
        final dist = Dist();
        final link = item.getElementsByTagName('a')[0];
        dist.title = link.text;
        final uri = link.attributes["href"];
        var ure = RegExp(r"fid=(\d+)&");
        var res = ure.firstMatch(uri!)!;
        dist.id = int.parse(res.group(1)!);
        bigdist.dists.add(dist);
      }
      bigdists.add(bigdist);
    }
    return true;
  }
}
