import 'package:XhView/tool/replymodel.dart';
import 'package:flutter/material.dart';
import '../widget/postthread.dart';

class PostthreadPage extends StatelessWidget {
  const PostthreadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postthreadargs =
        ModalRoute.of(context)!.settings.arguments as PostthreadArgs;
    return Scaffold(
        appBar: AppBar(
          title: Text("发帖(${postthreadargs.name})"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ),
        body: PostthreadView(args: postthreadargs));
  }
}
