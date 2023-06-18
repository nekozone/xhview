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
  ItemStyle? textstyle;
  int? quoteid;
  String? quotesrc;
  Contitem(this.type);
  String? rawHtml;
}

class ItemStyle {
  String? color;
  String? size;
  bool? bold;
}

Contitem? phl(dom.Node ele) {
  late Contitem resitem;
  if (ele is dom.Text) {
    resitem = Contitem('Text');
    resitem.text = ele.text;
    // print('type : Text->cont: ${ele.text};');
  } else if (ele is dom.Element) {
    // print("localname:${ele.localName} haschile:${ele.hasChildNodes()}");
    if (ele.localName == 'a') {
      resitem = Contitem('a');
      resitem.linkurl = ele.attributes['href'];
    } else if (ele.localName == 'img') {
      resitem = Contitem('img');
      resitem.imgurl = ele.attributes['src'];
      resitem.imgwidth = double.tryParse(ele.attributes['width'] ?? '');
      resitem.imgheight = double.tryParse(ele.attributes['height'] ?? '');
    } else if (ele.localName == "div") {
      if (ele.className.contains("quote")) {
        // resitem = Contitem('quote');
        return phl(ele.nodes[0]);
      } else {
        resitem = Contitem('div');
      }
    } else if (ele.localName == "blockquote") {
      final alist = ele.getElementsByTagName("a");
      if (alist.isNotEmpty) {
        resitem = Contitem('quote-reply');
        final qurl = alist[0].attributes['href'];
        final qreg = RegExp("pid=(\\d+)");
        final qmatch = qreg.firstMatch(qurl!);
        if (qmatch != null) {
          resitem.quoteid = int.parse(qmatch.group(1)!);
        }
        resitem.quotesrc = alist[0].text;
        alist[0].remove();
        ele.nodes.removeAt(0);
        resitem.text = ele.text;
        return resitem;
      } else {
        resitem = Contitem('quote');
        resitem.text = ele.text;
        return resitem;
      }
    } else if (ele.localName == "strong") {
      resitem = Contitem('div');
      resitem.textstyle = ItemStyle()..bold = true;
    } else if (ele.localName == "font") {
      resitem = Contitem('div');
      final fsize = ele.attributes['size'];
      final color = ele.attributes['color'];
      final nstyle = ItemStyle();
      if (fsize != null) {
        nstyle.size = fsize;
      }
      if (color != null) {
        nstyle.color = color;
      }
      resitem.textstyle = nstyle;
    } else {
      resitem = Contitem('u-${ele.localName}');
    }

    // return null;
  } else {
    // print('runtimetype : ${ele.runtimeType};');
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
  } else if (item.type == 'quote') {
    restr = "Quote : ${item.text}";
  } else if (item.type == 'quote-reply') {
    restr =
        "Quote ${item.quoteid} | ${item.quotesrc} | ${item.text?.replaceAll("\n", '\\n')}";
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

List<String> rphl2(Contitem item, ItemStyle? parentstyle, String? linksrc) {
  // late String restr;
  List<String> chdstr = [];
  if (item.type == "Text") {
    final linkstr = linksrc != null ? "link:$linksrc" : "";
    late String resstr;
    if (parentstyle != null || item.textstyle != null) {
      final isbord = item.textstyle?.bold ?? parentstyle?.bold ?? false;
      final size = item.textstyle?.size ?? parentstyle?.size ?? "";
      final color = item.textstyle?.color ?? parentstyle?.color ?? "";
      resstr =
          "Text->text(${isbord ? 'bord' : ''} $size $color $linkstr):[${item.text?.replaceAll("\n", '').replaceAll(' ', '')} ]";
    } else {
      resstr =
          "Text->text($linkstr):[${item.text?.replaceAll("\n", '').replaceAll(' ', '')}]";
    }
    chdstr.add(resstr);
  } else if (item.type == 'a') {
    final rlink = item.linkurl;
    for (var chitem in item.children!) {
      final chstr = rphl2(chitem, item.textstyle, rlink);
      chdstr.addAll(chstr);
      for (var i = 0; i < chstr.length; i++) {
        final ch = chstr[i];
        chdstr.add(ch);
      }
    }
  } else if (item.type == 'img') {
    final sizestr = item.imgwidth != null
        ? "width: ${item.imgwidth} height :${item.imgheight}"
        : "";
    final resstr = "Img->img( $sizestr ):${item.imgurl}";
    chdstr.add(resstr);
  } else if (item.type == 'quote') {
    final resstr = "Quote : ${item.text}";
    chdstr.add(resstr);
  } else if (item.type == 'quote-reply') {
    final resstr =
        "Quote [${item.quoteid} | ${item.quotesrc} | ${item.text?.replaceAll("\n", '').replaceAll(' ', '')}]";
    chdstr.add(resstr);
  } else {
    if (item.children != null) {
      late ItemStyle newstyle;
      if (parentstyle != null || item.textstyle != null) {
        final isbord = item.textstyle?.bold ?? parentstyle?.bold ?? false;
        final size = item.textstyle?.size ?? parentstyle?.size ?? "";
        final color = item.textstyle?.color ?? parentstyle?.color ?? "";
        final sty = ItemStyle();
        sty.bold = isbord;
        sty.size = size;
        sty.color = color;
        newstyle = sty;
      } else {
        newstyle = ItemStyle();
      }
      for (var i = 0; i < item.children!.length; i++) {
        final child = item.children![i];
        final rchild = rphl2(child, newstyle, linksrc);
        chdstr.addAll(rchild);
      }
    }
  }
  return chdstr;
}

const rawHtml2 = """

""";

void main(List<String> args) {
  var rawHtmla = rawHtml2;
  rawHtmla = rawHtmla.replaceAll('<br>', '\n');
  rawHtmla = rawHtmla.replaceAll('<br />', '\n');
  rawHtmla = rawHtmla.replaceAll('<br/>', '\n');

  final document = parser.parse(rawHtmla);
  final message = document.getElementsByClassName('message');
  final messageEle = message[0];
  final kn = phl(messageEle);
  print("****");
  print(rphl2(kn!, null, null));
}
// https://github.com/zhaolongs/flutter_html_rich_text/blob/master/lib/src/utils/parser_html_utils.dart
// https://zhuanlan.zhihu.com/p/254997655