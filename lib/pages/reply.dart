import 'package:flutter/material.dart';
import '../tool/replymodel.dart';
// import '../tool/status.dart';
import '../widget/reply.dart';

class ReplyPage extends StatelessWidget {
  const ReplyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final replyargs = ModalRoute.of(context)!.settings.arguments as ReplyArgs;
    return Scaffold(
        appBar: AppBar(
          title: const Text("回复"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ),
        body: ReplyView(args: replyargs));
  }
}

class ReplyViewx extends StatefulWidget {
  const ReplyViewx({super.key, required this.args});
  final ReplyArgs args;
  @override
  State<ReplyViewx> createState() => _ReplyViewxState();
}

class _ReplyViewxState extends State<ReplyViewx> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        ListTile(
          title: const Text("Fid"),
          subtitle: Text(widget.args.fid.toString()),
        ),
        ListTile(
          title: const Text("Tid"),
          subtitle: Text(widget.args.tid.toString()),
        ),
        ListTile(
          title: const Text("Pid"),
          subtitle: Text(widget.args.pid == null
              ? "underfined"
              : widget.args.pid.toString()),
        ),
        // ListTile(
        //   title: const Text("FormHash"),
        //   subtitle: SelectableText(XhStatus.xhstatus.isLogin
        //       ? (XhStatus.xhstatus.userinfo.formhash ?? "underfined")
        //       : "未登录"),
        // )
      ]),
    );
  }
}
