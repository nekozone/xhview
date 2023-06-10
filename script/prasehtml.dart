import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

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

Contitem? phl(dom.Node ele) {
  late Contitem resitem;
  if (ele is dom.Text) {
    resitem = Contitem('Text');
    resitem.text = ele.text;
    // print('type : Text->cont: ${ele.text};');
  } else if (ele is dom.Element) {
    print("localname:${ele.localName} haschile:${ele.hasChildNodes()}");
    if (ele.localName == 'a') {
      resitem = Contitem('a');
      resitem.linkurl = ele.attributes['href'];
    } else if (ele.localName == 'img') {
      resitem = Contitem('img');
      resitem.imgurl = ele.attributes['src'];
      resitem.imgwidth = double.tryParse(ele.attributes['width'] ?? '');
      resitem.imgheight = double.tryParse(ele.attributes['height'] ?? '');
    } else if (ele.localName == "div") {
      resitem = Contitem('div');
    } else {
      resitem = Contitem('u-${ele.localName}');
    }

    // return null;
  } else {
    print('runtimetype : ${ele.runtimeType};');
    resitem = Contitem('ur-${ele.runtimeType}');
  }

  if (ele.hasChildNodes()) {
    List<Contitem> ch = [];
    // print(object)
    for (var i = 0; i < ele.nodes.length; i++) {
      final node = ele.nodes[i];
      final rs = phl(node);
      if (rs != null) {
        ch.add(rs);
      }
    }
    resitem.children = ch;
  }
  return resitem;
}

String rphl(Contitem item) {
  late String restr;
  if (item.type == 'Text') {
    final rtext = item.text;
    restr = "Text->text:${rtext?.replaceAll("\n", '\\n')}";
  } else if (item.type == 'a') {
    final rlink = item.linkurl;
    restr = "A->link:${rlink}";
  } else if (item.type == 'img') {
    final rimg = item.imgurl;
    final rwidth = item.imgwidth != null ? "width: ${item.imgwidth}}" : "";
    final rheight = item.imgheight != null ? "height: ${item.imgheight}}" : "";
    restr = "Img->url:$rimg $rwidth $rheight";
  } else {
    restr = "DivOrUnknow->type:${item.type}";
  }

  if (item.children != null) {
    var chdstr = '';
    for (var i = 0; i < item.children!.length; i++) {
      final child = item.children![i];
      final rchild = rphl(child);
      chdstr += i == (item.children!.length - 1) ? "[$rchild]" : "[$rchild],";
    }
    return "[$restr :->{$chdstr}]";
  }
  return "[$restr]";
}

void main(List<String> args) {
  rawHtml = rawHtml.replaceAll('<br>', '\n');
  rawHtml = rawHtml.replaceAll('<br />', '\n');
  rawHtml = rawHtml.replaceAll('<br/>', '\n');

  final document = parser.parse(rawHtml);
  final message = document.getElementsByClassName('message');
  final messageEle = message[0];
  final kn = phl(messageEle);
  print(rphl(kn!));
}
// https://github.com/zhaolongs/flutter_html_rich_text/blob/master/lib/src/utils/parser_html_utils.dart
// https://zhuanlan.zhihu.com/p/254997655