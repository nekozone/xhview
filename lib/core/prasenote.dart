import '../tool/notemodel.dart';
import 'package:html/dom.dart' as dom;

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
      final alink = Uri.parse(ele.attributes['href']!);
      if (alink.isAbsolute) {
        resitem.linkurl = ele.attributes['href'];
      } else {
        resitem.linkurl = 'https://bbs.dippstar.com/$alink';
      }
    } else if (ele.localName == 'img') {
      resitem = Contitem('img');
      final picurl = Uri.parse(ele.attributes['src']!);
      if (picurl.isAbsolute) {
        resitem.imgurl = ele.attributes['src'];
      } else {
        resitem.imgurl = 'https://bbs.dippstar.com/$picurl';
      }
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
    } else if (ele.localName == "iframe") {
      resitem = Contitem('a');
      resitem.linkurl = ele.attributes['src'];
      final childitem = Contitem('Text');
      childitem.text = ele.attributes['src'];
      resitem.children = [childitem];
      return resitem;
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
