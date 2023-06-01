import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../tool/profile.dart';
import '../widget/chouti.dart';
import '../tool/status.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Chouti(page: 'home'),
        appBar: AppBar(title: const Text("星海论坛"), centerTitle: true),
        body: const SingleChildScrollView(
          child: IndexList(),
        ));
  }
}

class IndexList extends StatelessWidget {
  const IndexList({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    if (!XhStatus.isErr) {
      return const Text("加载失败");
    }
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(children: distListWidget(themeData)),
    );
  }

  List<Widget> distListWidget(ThemeData themeData) {
    List<Widget> distWidgetList = [];
    for (var item in XhStatus.xhstatus.bigdists) {
      distWidgetList.add(Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            Text(
              item.title,
              style: TextStyle(
                fontSize: themeData.textTheme.titleMedium?.fontSize,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: distWidget(item.dists, themeData),
              ),
            )
          ],
        ),
      ));
    }
    distWidgetList.add(Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Text(
            "帖子数:${XhStatus.xhstatus.info.notenum}",
            style: TextStyle(
              fontSize: themeData.textTheme.titleMedium?.fontSize,
            ),
          ),
          Text(
            "在线人数:${XhStatus.xhstatus.info.online}",
            style: TextStyle(
              fontSize: themeData.textTheme.titleMedium?.fontSize,
            ),
          ),
          Text(
            "注册人数:${XhStatus.xhstatus.info.people}",
            style: TextStyle(
              fontSize: themeData.textTheme.titleMedium?.fontSize,
            ),
          ),
        ],
      ),
    ));
    return distWidgetList;
  }

  List<Widget> distWidget(List dists, themeData) {
    List<Widget> distWidgetList = [];
    for (var item in dists) {
      distWidgetList.add(Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: TextButton(onPressed: () {}, child: Text(item.title)),
      ));
    }
    return distWidgetList;
  }
}
