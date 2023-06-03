import 'package:flutter/material.dart';
import '../widget/chouti.dart';
import '../core/threadlist.dart';
import '../tool/forummodel.dart';

class Forum extends StatelessWidget {
  const Forum({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ForumArgs;
    return Scaffold(
        drawer: const Chouti(page: 'forum'),
        appBar: AppBar(title: Text(args.title), centerTitle: true),
        body: ForumView(id: args.id));
  }
}

class ForumView extends StatefulWidget {
  const ForumView({super.key, required this.id});
  final int id;

  @override
  State<ForumView> createState() => _ForumViewState();
}

class _ForumViewState extends State<ForumView> {
  late Threads threads;
  final List<ThreadItem> threadlist = [];
  final List<int> threadIdList = [];
  late dynamic _firstpage;
  int maxpage = 1;
  int nowPage = 1;
  int nowItem = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    threads = Threads(widget.id);
    _firstpage = firstpage();
  }

  @override
  Widget build(BuildContext context) {
    print("FBUILD");
    return FutureBuilder(future: _firstpage, builder: fbuild);
  }

  getpage({int page = 1}) async {
    bool res = await threads.getList(ppage: page);
    final list = threads.threadlist;
    setState(() {
      for (var item in list) {
        if (threadIdList.contains(item.tid)) {
          continue;
        }
        threadIdList.add(item.tid);
        threadlist.add(item);
      }
      nowPage = page;
      maxpage = threads.maxpage;
      nowItem = threadlist.length;
    });
    return res;
  }

  firstpage() async {
    bool res = await getpage();
    return res;
  }

  Widget fbuild(BuildContext context, AsyncSnapshot snapshot) {
    // return const Text("加载失败");
    if (snapshot.connectionState == ConnectionState.done) {
      print("done");
      if (snapshot.hasError) {
        return const Text("加载失败了，有错误。(1)");
      }
      final res = snapshot.data as bool;
      if (!res) {
        return const Text("加载失败了，有错误。(2)");
      }
      return displayView();
    } else {
      print("loading");
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget displayView() {
    print("displayView");
    return ListView.separated(
        padding: const EdgeInsets.only(top: 0),
        separatorBuilder: (context, index) => const Divider(height: .0),
        itemCount: nowItem,
        shrinkWrap: true,
        // shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          print("itemBuilder:${index}");
          if (index == threadlist.length - 1) {
            if (nowPage < maxpage) {
              getpage(page: nowPage + 1);
              return Container(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                // alignment: Alignment.center,
                child: const SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              );
            } else {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "我是有底线的",
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
              );
            }
          } else {
            final item = threadlist[index];
            return ListTile(
              title: Text(item.title),
              subtitle: Text(item.author),
            );
          }
          // return ListTile(title: Text("$index"));
        });
  }
}
