import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:html/parser.dart';

final dio = Dio()..httpClientAdapter = Http2Adapter(ConnectionManager());

class NoteItem {
  late String title;
  late String author;
  late int tid;
  late int replynum;
  bool isTu = false;
}

class DistList {
  late String title;
  late int id;
  late int page;
  late int maxpage;
  late List<NoteItem> threadlist;
  DistList(int tid) {
    id = tid;
  }

  init() async {
    return await getList();
  }

  Future<bool> getList({int ppage = 1}) async {
    page = ppage;
    final res = await dio.get(
        "https://bbs.dippstar.com/forum.php?mod=forumdisplay&fid=${id}&page=${ppage}&mobile=2");
    final document = parse(res.data);
    // 获取名称
    final nameele = document.getElementsByClassName("name");
    if (nameele.isEmpty) {
      title = "underfind";
    } else {
      final nlist = nameele[0];
      final msg = nlist.getElementsByTagName("a");
      if (msg.isEmpty) {
        title = nlist.text;
      } else {
        msg[0].remove();
        // TODO: 消息处理
        title = nlist.text;
      }
    }

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

    // 获取帖子列表

    final itemsele = document.getElementsByClassName("threadlist");
    if (itemsele.isEmpty) {
      return false;
    }
    final items = itemsele[0].getElementsByTagName("li");
    if (items.isEmpty) {
      return false;
    }
    threadlist = []; // 清空列表
    for (var item in items) {
      final noteitem = NoteItem();
      final nameauthele = item.getElementsByTagName('a');
      if (nameauthele.isEmpty) {
        continue;
      }

      final linkurl = nameauthele[0].attributes["href"];
      final linkre = RegExp(r"tid=(\d+)&");
      final linkmatch = linkre.firstMatch(linkurl!)!;
      noteitem.tid = int.parse(linkmatch.group(1)!);

      final authnamele = nameauthele[0].getElementsByClassName('by');
      if (authnamele.isEmpty) {
        noteitem.author = "underfind";
      } else {
        noteitem.author = authnamele[0].text;
        authnamele[0].remove();
      }
      noteitem.title = nameauthele[0].text.replaceAll("\n", '');

      final tunm = item.getElementsByClassName("num");
      noteitem.replynum = tunm.isEmpty ? 0 : int.parse(tunm[0].text);

      final tu = item.getElementsByClassName("icon_tu");
      noteitem.isTu = tu.isNotEmpty;

      threadlist.add(noteitem);
    }
    return true;
  }
}

Future<void> main(List<String> args) async {
  print("Hello World");
  final dist = DistList(124);
  final hu = await dist.init();
  print(hu);
  // print(hu);
  print(
      "title: ${dist.title} id: ${dist.id} maxpage: ${dist.maxpage} page: ${dist.page}");
  for (var item in dist.threadlist) {
    print(
        "${item.title}-${item.tid} ${item.author} ${item.replynum} ${item.isTu}");
  }
}
