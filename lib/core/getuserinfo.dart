import '../network/connect.dart';
import 'package:html/parser.dart';

class UserInfo {
  String username;
  int uid;
  Uri avatar;
  String? formhash;
  UserInfo({required this.username, required this.uid, required this.avatar});
}

class MyInfo {
  late UserInfo info;
  Future<bool> get() async {
    final res = await NetWorkRequest.getpcHtml("https://bbs.dippstar.com/");
    // print("Get Index code: ${res.code}");
    if (res.code != 200) {
      return false;
    }
    final document = parse(res.data);
    final nameelement = document.getElementsByClassName("vwmy");
    if (nameelement.isEmpty) {
      // print('No vwmy');
      return false;
    }
    final namelink = nameelement[0].getElementsByTagName('a');
    if (namelink.isEmpty) {
      // print('No a');
      return false;
    }
    final username = namelink[0].text;
    final uidreg = RegExp(r"(\d+)");
    final uidstr = uidreg
        .allMatches(namelink[0].attributes['href']!)
        .elementAt(0)
        .group(0);
    final uid = int.parse(uidstr!);
    final avaele = document.getElementsByClassName("avt");
    if (avaele.isEmpty) {
      // print('No avt');
      return false;
    }
    final imgele = avaele[0].getElementsByTagName('img');
    if (imgele.isEmpty) {
      // print('No img');
      return false;
    }
    final avalink = imgele[0].attributes['src']?.replaceAll("small", 'big');
    if (avalink == null) {
      // print('No src');
      return false;
    }
    final avatar = Uri.parse(avalink);
    info = UserInfo(username: username, uid: uid, avatar: avatar);
    return true;
  }
}
