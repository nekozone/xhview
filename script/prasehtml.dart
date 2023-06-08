import 'package:html/parser.dart';
import 'package:html/dom.dart';

class Contitem {
  String type;
  String? text;
  List<Contitem>? children;
  String? linkurl;
  String? imgurl;
  double? imgwidth;
  double? imgheight;
  dynamic textstyle;
  Contitem(this.type);
}

String rawHtml = '''
<div class="message">
淮海决战前国军军头们莫非都这么二？一点局势都看不清？<br>
<br>
<a href="forum.php?mod=viewthread&amp;tid=975345&amp;aid=1017822&amp;from=album&amp;page=1&amp;mobile=2" class="orange"><img id="aimg_1017822" src="https://bbs.dippstar.com/data/attachment/forum/202306/08/172957ccai0z95ijip7s76.jpeg" alt="6080080A-3C74-4043-A9E3-3AA5B80164AB.jpeg" title="6080080A-3C74-4043-A9E3-3AA5B80164AB.jpeg" zsrc="https://bbs.dippstar.com/data/attachment/forum/202306/08/172957ccai0z95ijip7s76.jpeg" style="display: inline; visibility: visible;"></a>
<br>
</div>''';

Contitem? phl(Node ele) {
  if (ele.hasChildNodes()) {
    for (var sd in ele.nodes) {
      print("++++");
      print("+${sd.text}%%${sd.runtimeType}+");
      print("++++");
      phl(sd);
    }
  } else {
    print("+${ele.text}%%${ele.runtimeType}+");
  }
}

void main(List<String> args) {
  final document = parse(rawHtml);
  final message = document.getElementsByClassName('message');
  final messageEle = message[0];
  final kn = phl(messageEle);
  // print(kn);
}
// https://github.com/zhaolongs/flutter_html_rich_text/blob/master/lib/src/utils/parser_html_utils.dart
// https://zhuanlan.zhihu.com/p/254997655