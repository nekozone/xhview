import 'package:flutter/material.dart';
import '../tool/replymodel.dart';

class NoteFoot extends StatelessWidget {
  final int fid;
  final int tid;
  final int pid;
  const NoteFoot(
      {super.key, required this.fid, required this.tid, required this.pid});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(right: 10),
      width: double.infinity,
      // height: Theme.of(context).textTheme.bodyMedium?.fontSize,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        InkWell(
          onTap: () {
            final args = ReplyArgs(fid, tid, pid);
            Navigator.pushNamed(context, '/reply', arguments: args);
          },
          child: Icon(
            Icons.reply_all,
            size: Theme.of(context).textTheme.bodyMedium?.fontSize,
            color: (Theme.of(context).brightness == Brightness.light)
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColorLight,
          ),
        )
        // size: Theme.of(context).textTheme.bodyMedium?.fontSize),
      ]),
    );
  }
}
