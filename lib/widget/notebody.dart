import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import '../core/prasenote.dart';
import '../tool/notemodel.dart';
import '../tool/pcolor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteBody extends StatelessWidget {
  final dom.Node ele;
  const NoteBody({super.key, required this.ele});

  @override
  Widget build(BuildContext context) {
    final rescont = phl(ele);
    final spinlist = rphl(context, rescont!, null, null);
    return Container(
      padding: const EdgeInsets.fromLTRB(60, 2, 10, 2),
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: spinlist,
        ),
      ),
    );
  }

  List<InlineSpan> rphl(BuildContext context, Contitem item,
      ItemStyle? parentstyle, String? linksrc) {
    List<InlineSpan> chdstr = [];
    if (item.type == "Text") {
      late TextSpan textspan;
      bool xlink = false;
      if (linksrc != null && linksrc != "") {
        xlink = true;
      }
      if (parentstyle != null || item.textstyle != null) {
        final style = ItemStyle();
        style.bold = item.textstyle?.bold ?? parentstyle?.bold ?? false;
        style.size = item.textstyle?.size ?? parentstyle?.size ?? "";
        style.color = item.textstyle?.color ?? parentstyle?.color ?? "";
        textspan = TextSpan(
            text: item.text?.replaceAll("\n\n", '\n'),
            style: genstyle(style, context, islink: xlink),
            recognizer: xlink
                ? (TapGestureRecognizer()
                  ..onTap = () async {
                    final Uri url = Uri.parse(linksrc!);
                    if (!await launchUrl(url,
                        mode: LaunchMode.externalApplication)) {
                      throw 'Could not launch $url';
                    }
                  })
                : null);
      } else {
        textspan = TextSpan(
            text: item.text?.replaceAll("\n\n", '\n'),
            style: xlink
                ? const TextStyle(decoration: TextDecoration.underline)
                : null,
            recognizer: xlink
                ? (TapGestureRecognizer()
                  ..onTap = () async {
                    final Uri url0 = Uri.parse(linksrc!);
                    if (!await launchUrl(url0,
                        mode: LaunchMode.externalApplication)) {
                      throw 'Could not launch $url0';
                    }
                  })
                : null);
      }
      chdstr.add(textspan);
    } else if (item.type == 'a') {
      final rlink = item.linkurl;
      for (var chitem in item.children!) {
        final chstr = rphl(context, chitem, item.textstyle, rlink);
        chdstr.addAll(chstr);
      }
    } else if (item.type == 'img') {
      final imgurl = item.imgurl!;
      if (item.imgwidth != null && item.imgheight != null) {
        final imgwidth = item.imgwidth;
        final imgheight = item.imgheight;
        final imgspan = WidgetSpan(
            child: CachedNetworkImage(
          imageUrl: imgurl,
          width: imgwidth,
          height: imgheight,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) => Container(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Image.asset("assets/404.svg"),
        ));
        chdstr.add(imgspan);
      } else {
        final imgspan = WidgetSpan(
            child: CachedNetworkImage(
          imageUrl: imgurl,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: CircularProgressIndicator(
              value: progress.progress,
            ),
          ),
          errorWidget: (context, url, error) => Image.asset("assets/404.svg"),
        ));
        chdstr.add(imgspan);
      }
    } else if (item.type == 'quote') {
      final quotespin = WidgetSpan(
          child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColorDark,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: Text(item.text!),
      ));
      chdstr.add(quotespin);
    } else if (item.type == 'quote-reply') {
      final quotespin = WidgetSpan(
          child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColorDark,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: Text("引用: ${item.quotesrc} (${item.quoteid})\n${item.text}"),
      ));
      chdstr.add(quotespin);
    } else {
      if (item.children != null) {
        late ItemStyle? newstyle;
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
          newstyle = null;
        }
        for (var chitem in item.children!) {
          final chstr = rphl(context, chitem, newstyle, linksrc);
          chdstr.addAll(chstr);
        }
      }
    }
    return chdstr;
  }

  TextStyle genstyle(ItemStyle style, BuildContext context,
      {bool? islink = false}) {
    late double size;
    try {
      size = double.parse(style.size!);
    } catch (e) {
      size = 0;
    }
    if (style.color == null ||
        Theme.of(context).brightness == Brightness.dark) {
      return TextStyle(
        fontWeight: style.bold! ? FontWeight.bold : FontWeight.normal,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize! + size,
        decoration: islink! ? TextDecoration.underline : null,
      );
    }
    return TextStyle(
      fontWeight: style.bold! ? FontWeight.bold : FontWeight.normal,
      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize! + size,
      color: colorFromHex(style.color!),
      decoration: islink! ? TextDecoration.underline : null,
    );
  }
}
