import 'package:flutter/material.dart';
import '../tool/replymodel.dart';

class ReplyView extends StatefulWidget {
  const ReplyView({super.key, required this.args});
  final ReplyArgs args;

  @override
  State<ReplyView> createState() => _ReplyViewState();
}

class _ReplyViewState extends State<ReplyView> {
  bool hasallprams = false;
  bool isreplying = false;
  TextEditingController textcont = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.args.pid == null) {
      hasallprams = true;
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
    return SingleChildScrollView(
      child: Column(children: [inputbox(), replyButton()]),
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
                      setState(() {
                        isreplying = true;
                      });
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() {
                          isreplying = false;
                        });
                      });
                    },
              icon: const Icon(Icons.cloud_upload),
              label: Text(isreplying ? '回复中...' : '回复')),
        ));
  }
}
