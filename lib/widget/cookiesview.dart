import 'dart:io';

import 'package:flutter/material.dart';
import '../network/connect.dart';

class CookiesView extends StatefulWidget {
  const CookiesView({super.key});

  @override
  State<CookiesView> createState() => _CookiesViewState();
}

class _CookiesViewState extends State<CookiesView> {
  List<Cookie> cookieslist = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    getCookies();
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (cookieslist.isNotEmpty) {
        final List<Widget> lw = [];
        for (var item in cookieslist) {
          lw.add(cookiesItem(context, item.name, item.value));
        }
        return Column(children: lw);
      } else {
        return const Center(child: Text('没有cookie'));
      }
    }
  }

  Widget cookiesItem(context, String name, String value) {
    return ListTile(title: Text(name), subtitle: Text(value));
  }

  void getCookies() async {
    final cookjar = NetWorkRequest.jar;
    final cookies =
        await cookjar.loadForRequest(Uri.parse("https://bbs.dippstar.com/"));
    setState(() {
      cookieslist = cookies;
      loaded = true;
    });
  }
}
