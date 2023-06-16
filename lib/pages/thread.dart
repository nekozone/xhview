import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import '../core/thread.dart';
import '../tool/threadmodel.dart';
import '../widget/error.dart';
import '../widget/notehead.dart';
import '../widget/notebody.dart';
import '../widget/notefoot.dart';

class Thread extends StatefulWidget {
  const Thread({super.key});

  @override
  State<Thread> createState() => _ThreadState();
}

class _ThreadState extends State<Thread> {
  late ThreadArgs args;
  late String pagetitle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ThreadArgs;
    setState(() {
      pagetitle = args.title;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(pagetitle),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: ThreadView(id: args.id, setpagetitle: setpagetitle),
    );
  }

  void setpagetitle(String newtitle) {
    if (pagetitle != newtitle) {
      setState(() {
        pagetitle = newtitle;
      });
    }
  }
}

class ThreadView extends StatefulWidget {
  const ThreadView({super.key, required this.id, required this.setpagetitle});
  final int id;
  final Function setpagetitle;

  @override
  State<ThreadView> createState() => _ThreadViewState();
}

class _ThreadViewState extends State<ThreadView> {
  bool isloading = false;
  late Posts posts;
  final List<PostItem> postlist = [];
  late dynamic _firstpage;
  int maxpage = 1;
  int nowPage = 1;
  int nowItem = 0;

  @override
  void initState() {
    super.initState();
    posts = Posts(widget.id);
    _firstpage = firstpage();
  }

  Future<bool> getpage({int page = 1}) async {
    isloading = true;
    bool res = await posts.getList(ppage: page);
    final list = posts.postlist;
    setState(() {
      for (var item in list) {
        postlist.add(item);
      }
      nowPage = page;
      maxpage = posts.maxpage;
      nowItem = postlist.length;
      if (nowPage == maxpage) {
        nowItem += 1;
      }
    });
    isloading = false;
    return res;
  }

  Future<bool> firstpage() async {
    bool res = await getpage();
    if (res) {
      widget.setpagetitle(posts.fname);
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _firstpage, builder: fbuild);
  }

  Widget fbuild(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return const ErrorDisplay(
            "加载失败了，有错误。", "0cb59f1b-d142-4f45-b949-249456b2b336");
      }
      final res = snapshot.data as bool;
      if (!res) {
        return const ErrorDisplay(
            "加载失败了，有错误。", "831fcbe6-f9ab-4a7a-b28b-3253879bb969");
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
          separatorBuilder: (context, index) => const Divider(
            height: 0,
          ),
          itemCount: nowItem,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index >= postlist.length - 1) {
              if (nowPage < maxpage) {
                getpage(page: nowPage + 1);
                return Container(
                  padding: const EdgeInsets.fromLTRB(30, 3, 30, 3),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
            }
            if (index >= postlist.length && nowPage == maxpage) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "没有更多了",
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
              );
            } else {
              final item = postlist[index];
              var rawHtmlStr = item.html.outerHtml;
              rawHtmlStr = rawHtmlStr.replaceAll("</p>", "</p><br>");
              rawHtmlStr = rawHtmlStr.replaceAll("<br>", "\n");
              rawHtmlStr = rawHtmlStr.replaceAll("<br/>", "\n");
              rawHtmlStr = rawHtmlStr.replaceAll("<br />", "\n");
              final phtml = parser.parse(rawHtmlStr);
              if (nowPage == 1 && index == 0) {
                return Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        // height: 40,
                        child: Text(
                          posts.title,
                          // strutStyle: const StrutStyle(
                          // forceStrutHeight: true, height: 1.5, leading: 0),
                          style: TextStyle(
                              // wordSpacing: 100,
                              height: 1,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.fontSize),
                        )),
                    NoteHead(
                        username: item.author,
                        avatar: item.avatar,
                        time: item.time,
                        lou: item.lou,
                        pid: item.pid,
                        uid: item.uid),
                    const Divider(),
                    NoteBody(ele: phtml),
                    const NoteFoot()
                  ],
                );
              }
              return Column(
                children: [
                  NoteHead(
                      username: item.author,
                      avatar: item.avatar,
                      time: item.time,
                      lou: item.lou,
                      pid: item.pid,
                      uid: item.uid),
                  const Divider(),
                  NoteBody(ele: phtml),
                  const NoteFoot()
                ],
              );
            }
          },
        ));
  }

  Future onRefresh() async {
    if (isloading) {
      await Future.delayed(const Duration(seconds: 3));
      return;
    }
    postlist.clear();
    await getpage();
    isloading = true;
    Future.delayed(const Duration(seconds: 20)).then((value) {
      isloading = false;
    });
    return;
    // print("EndRefresh");
  }
}
