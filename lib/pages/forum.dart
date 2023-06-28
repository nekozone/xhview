import 'package:flutter/material.dart';
import '../widget/chouti.dart';
import '../widget/error.dart';
import '../core/threadlist.dart';
import '../tool/forummodel.dart';
import '../tool/threadmodel.dart';
import '../tool/replymodel.dart';

class Forum extends StatelessWidget {
  const Forum({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ForumArgs;
    return Scaffold(
        drawer: const Chouti(page: 'forum'),
        appBar: AppBar(
          title: Text(args.title),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  final postthreadargs = PostthreadArgs(args.id, args.title);
                  Navigator.pushNamed(context, '/postthread',
                      arguments: postthreadargs);
                },
                icon: const Icon(Icons.addchart))
          ],
        ),
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
  bool isloading = false;
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
    threads = Threads(widget.id);
    _firstpage = firstpage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _firstpage, builder: fbuild);
  }

  getpage({int page = 1}) async {
    isloading = true;
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
      if (nowPage == maxpage) {
        nowItem += 1;
      }
    });
    isloading = false;
    return res;
  }

  firstpage() async {
    bool res = await getpage();
    return res;
  }

  Widget fbuild(BuildContext context, AsyncSnapshot snapshot) {
    // return const Text("加载失败");
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return const ErrorDisplay(
            "加载失败了，有错误。", "e7ab1c06-13e6-4c77-9583-dc97d41494d4");
      }
      final res = snapshot.data as bool;
      if (!res) {
        return const ErrorDisplay(
            "加载失败了，有错误。", "aac65caa-e11b-4d16-b7df-6df0ca065ace");
      }
      return displayView();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget displayView() {
    return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
            padding: const EdgeInsets.only(top: 0),
            separatorBuilder: (context, index) => const Divider(height: .0),
            itemCount: nowItem,
            shrinkWrap: true,
            // shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index >= threadlist.length - 1) {
                if (nowPage < maxpage) {
                  getpage(page: nowPage + 1);
                  return Container(
                    padding: const EdgeInsets.fromLTRB(30, 3, 30, 3),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                if (index >= threadlist.length && nowPage == maxpage) {
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "没有更多了",
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    ),
                  );
                }
              } else {
                final item = threadlist[index];

                return InkWell(
                  onTap: () {
                    final args = ThreadArgs(threads.title, item.tid, widget.id);
                    Navigator.pushNamed(context, '/thread', arguments: args);
                  },
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.author),
                        Row(
                          children: [
                            Icon(
                              Icons.chat,
                              size: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize,
                              // color: Theme.of(context).primaryColorDark,
                            ),
                            Text(item.replynum.toString())
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
              return null;
              // return ListTile(title: Text("$index"));
            }));
  }

  Future onRefresh() async {
    if (isloading) {
      await Future.delayed(const Duration(seconds: 3));
      return;
    }
    threadlist.clear();
    threadIdList.clear();
    await getpage();
    isloading = true;
    Future.delayed(const Duration(seconds: 20)).then((value) {
      isloading = false;
    });
    return;
    // print("EndRefresh");
  }
}
