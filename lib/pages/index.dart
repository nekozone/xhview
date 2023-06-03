import 'package:XhView/core/threadlist.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../tool/profile.dart';
import 'package:flutter/material.dart';
import '../widget/chouti.dart';
import '../tool/status.dart';
import '../tool/forummodel.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Chouti(page: 'home'),
        appBar: AppBar(title: Text(XhStatus.xhstatus.name), centerTitle: true),
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
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: distListWidget(themeData, context)),
    );
  }

  List<Widget> distListWidget(ThemeData themeData, context) {
    List<Widget> distWidgetList = [];
    for (var item in XhStatus.xhstatus.bigdists) {
      distWidgetList.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: TextStyle(
              // height: 0.2,

              fontSize: themeData.textTheme.titleLarge?.fontSize,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 3, bottom: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(thickness: 1, color: themeData.primaryColorLight),
                ...distWidget(item.dists, themeData, context)
              ],
            ),
          )
        ],
      ));
    }
    distWidgetList.add(Divider(
      thickness: 2,
      color: themeData.primaryColorDark,
    ));
    distWidgetList.add(Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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

  List<Widget> distWidget(List dists, themeData, context) {
    List<Widget> distWidgetList = [];
    for (var item in dists) {
      distWidgetList.add(Container(
        padding: const EdgeInsets.only(top: 1, bottom: 1),
        child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/forum',
                  arguments: ForumArgs(item.title, item.id));
            },
            child: Text(item.title,
                style: TextStyle(
                  fontSize: themeData.textTheme.titleMedium?.fontSize,
                ))),
      ));
    }
    return distWidgetList;
  }
}
