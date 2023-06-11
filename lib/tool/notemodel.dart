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
