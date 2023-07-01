// import 'package:dio/dio.dart';
// import 'package:intl/intl.dart';
// import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
// import '../tool/status.dart';
import '../network/connect.dart';
import '../tool/blocklist.dart';
import '../tool/profile.dart';

// final dio = Dio()..httpClientAdapter = Http2Adapter(ConnectionManager());

class PostItem {
  late String author;
  late String avatar;
  late int pid;
  late int uid;
  late int lou;
  late String time;
  late Element html;
}

class Posts {
  late int threadid;
  late int page;
  late int maxpage;
  late String title;
  late String fname;
  late List<PostItem> postlist;
  late bool status;
  Posts(this.threadid);

  Future<bool> getList({int ppage = 1}) async {
    page = ppage;
    final res = await NetWorkRequest.getHtml(
        "https://bbs.dippstar.com/forum.php?mod=viewthread&tid=$threadid&extra=page%3D1&page=$ppage&mobile=2");
    // final res = await dio.get(
    // "https://bbs.dippstar.com/forum.php?mod=viewthread&tid=${threadid}&extra=page%3D1&page=${ppage}&mobile=2");
    if (res.code != 200) {
      status = false;
      return false;
    }
    final document = parse(res.data);
    // 获取板块名称
    final headerele = document.getElementsByClassName("header");
    if (headerele.isEmpty) {
      fname = "underfind";
    }
    final nameele = headerele[0].getElementsByClassName("name");
    if (nameele.isEmpty) {
      fname = "underfind";
    }
    final nlist = nameele[0];
    final msg = nlist.getElementsByTagName("a");
    if (msg.isEmpty) {
      fname = nlist.text;
    } else {
      msg[0].remove();
      // TODO: 消息处理
      fname = nlist.text;
    }

    // 获取帖子标题

    final titleele = document.getElementsByClassName("postlist");
    if (titleele.isEmpty) {
      return false;
    }
    final h2ele = titleele[0].getElementsByTagName("h2");
    if (h2ele.isEmpty) {
      return false;
    }
    final haele = h2ele[0].getElementsByTagName('a');
    if (haele.isNotEmpty) {
      haele[0].remove();
    }

    title = h2ele[0].text;

    // 获取最大页数

    final pagenum = document.getElementsByClassName("pg");
    if (pagenum.isEmpty) {
      maxpage = 1;
    } else {
      final pagespanlist = pagenum[0].getElementsByTagName("span");
      if (pagespanlist.isEmpty) {
        maxpage = 1;
      } else {
        final pgtext = pagespanlist[0].text;
        final pagere = RegExp(r"(\d+)"); // 匹配数字
        final match = pagere.allMatches(pgtext);
        if (match.isEmpty) {
          maxpage = 1;
        } else {
          maxpage = int.parse(match.elementAt(0).group(0)!);
        }
      }
    }
    // 获取formhash
    // if (XhStatus.xhstatus.isLogin) {
    //   final formhashele = document.querySelector('input[name="formhash"]');
    //   if (formhashele != null) {
    //     XhStatus.xhstatus.userinfo.formhash = formhashele.attributes['value']!;
    //   }
    // }
    // 获取帖子列表
    postlist = _getitem(document);
    return true;
  }

  List<PostItem> _getitem(Document document) {
    final List<PostItem> postlist = [];
    final plcele = document.getElementsByClassName("plc");
    if (plcele.isEmpty) {
      return postlist;
    }
    for (var plcitem in plcele) {
      final msgele = plcitem.getElementsByClassName("message");
      if (msgele.isEmpty) {
        continue;
      }
      final item = PostItem();

      // 获取pid
      final plcid = plcitem.attributes["id"];
      final numexp = RegExp(r"(\d+)");
      final plcidmatch = numexp.firstMatch(plcid!);
      item.pid = int.parse(plcidmatch!.group(0)!);

      // 获取楼层
      final louele = plcitem.getElementsByClassName("grey");
      if (louele.isEmpty) {
        // item.lou = 0;
        continue;
      } else {
        final louem = louele[0].getElementsByTagName("em");
        if (louem.isEmpty) {
          item.lou = 0;
        } else {
          final loumatch = numexp.firstMatch(louem[0].text);
          item.lou = int.parse(loumatch!.group(0)!);
        }
      }

      // 获取作者名称和uid
      final aele = louele[0].getElementsByTagName("a");
      if (aele.isEmpty) {
        item.author = "underfind";
        item.uid = 0;
      } else {
        item.author = aele[0].text;
        final uidmatch = numexp.firstMatch(aele[0].attributes["href"]!);
        item.uid = int.parse(uidmatch!.group(0)!);
      }

      // 检测黑名单

      if (UserProfiles.blocklist) {
        if (BlockList.uid.contains(item.uid)) {
          continue;
        }
      }

      // 获取作者头像url
      final avatarele = plcitem.getElementsByClassName("avatar");
      if (avatarele.isEmpty) {
        continue;
      }
      final urlele = avatarele[0].getElementsByTagName("img");
      if (urlele.isEmpty) {
        continue;
      }
      item.avatar = urlele[0].attributes["src"]!.replaceAll("small", "big");

      // 获取发帖时间
      final relaele = plcitem.getElementsByClassName("rela");
      if (relaele.isEmpty) {
        continue;
      }
      final shoucangem = relaele[0].getElementsByTagName("em");
      if (shoucangem.isNotEmpty) {
        for (var sce in shoucangem) {
          sce.remove();
        }
      }
      final timestr = relaele[0].text.replaceAll("\n", "").trim();
      // print("****${timestr}****");
      // final ptime = DateFormat('yyy-MM-dd HH:mm:ss').parse(timestr);

      item.time = timestr;

      // 添加在手机端上传的图片

      final mpicele = plcitem.getElementsByClassName("img_one");
      if (mpicele.isNotEmpty) {
        msgele[0].children.add(mpicele[0]);
      }

      // 获取帖子内容
      item.html = msgele[0];
      postlist.add(item);
    }
    return postlist;
  }
}
