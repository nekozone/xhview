import 'package:flutter/material.dart';
import '../core/thread.dart';
import '../tool/threadmodel.dart';
import '../widget/error.dart';

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
    args = ModalRoute.of(context)!.settings.arguments as ThreadArgs;
    pagetitle = args.title;
  }

  @override
  Widget build(BuildContext context) {
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
    bool res = await posts.getList(ppage: page);
    final list = posts.postlist;
    setState(() {
      for (var item in list) {
        postlist.add(item);
      }
      nowPage = page;
      maxpage = posts.maxpage;
      nowItem = postlist.length;
    });
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
}
