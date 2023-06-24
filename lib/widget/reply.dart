import 'package:flutter/material.dart';
import '../tool/replymodel.dart';
import '../widget/error.dart';
import '../tool/status.dart';
import '../core/reply.dart';

class ReplyView extends StatefulWidget {
  const ReplyView({super.key, required this.args});
  final ReplyArgs args;

  @override
  State<ReplyView> createState() => _ReplyViewState();
}

class _ReplyViewState extends State<ReplyView> {
  bool hasallprams = false;
  bool isreplying = false;
  late Reply reply;
  late ReplyArgs arg;
  Map<String, dynamic> postprame = {};
  String pichash = "";
  TextEditingController textcont = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (widget.args.pid == null) {
    //   hasallprams = true;
    // }
    _init();
  }

  void _init() async {
    arg = widget.args;
    if (XhStatus.xhstatus.isLogin) {
      reply = Reply(arg.fid, arg.tid, arg.pid);
      final result = await reply.getinfo();
      if (result) {
        setState(() {
          hasallprams = true;
          postprame = reply.postdata;
          pichash = reply.pichash;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textcont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!XhStatus.xhstatus.isLogin) {
      return const ErrorDisplay("未登录", "3dd24949-1746-499f-8801-cb2067cbbb65");
    }

    return SingleChildScrollView(
      child: Column(children: [showItem(), inputbox(), replyButton()]),
    );
  }

  Widget inputbox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextField(
        minLines: 5,
        maxLines: 100,
        autofocus: true,
        decoration: const InputDecoration(labelText: "回复内容", hintText: "请输入内容"),
        controller: textcont,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget replyButton() {
    return Container(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(height: 55),
          child: ElevatedButton.icon(
              onPressed: (!hasallprams || isreplying)
                  ? null
                  : () {
                      // setState(() {
                      //   isreplying = true;
                      // });
                      _reply();
                      // Future.delayed(const Duration(seconds: 3), () {
                      //   setState(() {
                      //     isreplying = false;
                      //   });
                      // });
                    },
              icon: const Icon(Icons.cloud_upload),
              label: Text((isreplying) ? '回复中...' : '回复')),
        ));
  }

  // Widget showItemx() {
  //   List<Widget> items = [];
  //   if (hasallprams) {
  //     for (var item in postprame.entries) {
  //       items.add(ListTile(
  //         title: Text(item.key),
  //         subtitle: SelectableText(item.value.toString()),
  //       ));
  //     }
  //     items.add(ListTile(
  //       title: const Text("Posturl"),
  //       subtitle: SelectableText(reply.posturl),
  //     ));
  //   }
  //   items.add(ListTile(
  //     title: const Text("PicHash"),
  //     subtitle: SelectableText(pichash),
  //   ));
  //   return Column(children: items);
  // }

  Widget showItem() {
    if (hasallprams) {
      if (reply.postdata["noticeauthormsg"] != null &&
          reply.postdata["noticeauthormsg"] != "") {
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColorDark,
                width: 0.5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(6))),
          child: Text(reply.postdata["noticeauthormsg"]!),
        );
      } else {
        return Container(
          padding: const EdgeInsets.only(top: 10),
          child: const Divider(
            height: 0,
          ),
        );
      }
    } else {
      return Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Divider(
          height: 0,
        ),
      );
    }
  }

  void _reply() {
    if (isreplying) {
      return;
    }
    setState(() {
      isreplying = true;
    });
    if (textcont.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("请输入内容"),
      ));
      return;
    }
    reply.execreply(textcont.text).then((result) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("回复成功"),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error\n${reply.errinfo}}"),
        ));
        setState(() {
          isreplying = false;
        });
      }
    });
  }
}
