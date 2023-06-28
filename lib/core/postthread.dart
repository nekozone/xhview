import '../network/connect.dart';
import 'package:html/parser.dart';

class Postthread {
  late int fid;
  late String pichash;
  late String posturl;
  late String sub;
  late String msg;
  late String errinfo;
  final Map<String, String> postdata = {};
  Postthread(this.fid);

  Future<bool> getinfo() async {
    late ReturnData res;
    res = await NetWorkRequest.getHtml(
        "https://bbs.dippstar.com/forum.php?mod=post&action=newthread&fid=$fid&mobile=2");
    if (res.code != 200) {
      return false;
    }

    // 解析hidden回复参数
    // print(res.data);

    final document = parse(res.data);

    // 解析posturl

    final formele = document.querySelector("form");

    if (formele == null) {
      return false;
    }
    posturl = "https://bbs.dippstar.com/${formele.attributes['action']}";

    final hiddeninputeles = document.querySelectorAll("input[type=hidden]");

    if (hiddeninputeles.isEmpty) {
      return false;
    }
    for (var hiddeninput in hiddeninputeles) {
      final key = hiddeninput.attributes["name"];
      final value = hiddeninput.attributes["value"];
      if (key != null && value != null) {
        postdata[key] = value;
      }
    }

    // 解析checkbox参数
    // final xll = document.querySelector('input[name="noticetrimstr"]');
    final checkboxeles = document.querySelectorAll('input[type="checkbox"]');
    if (checkboxeles.isNotEmpty) {
      for (var checkboxele in checkboxeles) {
        if (checkboxele.attributes['disabled'] == 'disabled') {
          continue;
        }
        if (checkboxele.attributes['checked'] == 'checked') {
          final key = checkboxele.attributes['name'];
          final value = checkboxele.attributes['value'];
          if (key != null && value != null) {
            postdata[key] = value;
          } else if (key != null) {
            postdata[key] = "on";
          }
        }
      }
    }
    // 解析input text类型参数

    final texteles = document.querySelectorAll('input[type="text"]');
    if (texteles.isNotEmpty) {
      for (var textele in texteles) {
        final key = textele.attributes['name'];
        final value = textele.attributes['value'];
        if (key != null && value != null) {
          postdata[key] = value;
        }
      }
    }

    // 解析select类型参数
    final selecteles = document.querySelectorAll('select');
    if (selecteles.isNotEmpty) {
      for (var selectele in selecteles) {
        final key = selectele.attributes['name'];
        final chiele = selectele.querySelector('option');
        final value = chiele?.attributes['value'];
        if (key != null && value != null) {
          postdata[key] = value;
        }
      }
    }

    // 解析图片上传hash
    final scripteles = document.getElementsByTagName("script");
    final scriptx = scripteles[scripteles.length - 1].text;
    final repstr = RegExp(r'hash:"(.*?)"},');
    final match = repstr.firstMatch(scriptx);
    if (match != null) {
      pichash = match.group(1)!;
    } else {
      pichash = "";
    }

    return true;
  }

  Future<bool> execpost() async {
    if (msg.length <= 4) {
      msg = "\u200B\u200B\u200B\u200B$msg";
    }
    if (sub.length <= 4) {
      sub = "\u200B\u200B\u200B\u200B$sub";
    }

    postdata["subject"] = sub;
    postdata["message"] = msg;
    final res = await NetWorkRequest.post(posturl, formdata: postdata);
    if (res.code != 301) {
      final rawerrinfo = res.data;
      final errele = parse(rawerrinfo);
      final errinfoele = errele.querySelector("p");
      if (errinfoele != null) {
        errinfo = errinfoele.text;
      } else {
        errinfo = "未知错误";
      }
      return false;
    }
    return true;
  }
}
