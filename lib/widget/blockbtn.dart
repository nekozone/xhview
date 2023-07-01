import 'package:flutter/material.dart';
import '../tool/blocklist.dart';

class BlockBtn extends StatefulWidget {
  const BlockBtn({super.key, required this.uid, required this.username});
  final int uid;
  final String username;
  @override
  State<BlockBtn> createState() => _BlockBtnState();
}

class _BlockBtnState extends State<BlockBtn> {
  bool isblocked = false;
  late int id;
  late String name;

  void _checkblock() {
    id = widget.uid;
    name = widget.username;
    if (BlockList.uid.contains(id)) {
      isblocked = true;
    }
    if (BlockList.username.contains(name)) {
      isblocked = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkblock();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(height: 55),
          child: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: _onpress,
              icon: const Icon(Icons.block_flipped),
              label: Text(isblocked ? "取消屏蔽" : "加入黑名单")),
        ));
  }

  void _onpress() {
    if (isblocked) {
      BlockList.deluser(id);
    } else {
      BlockList.adduser(id, name);
    }
    setState(() {
      isblocked = !isblocked;
    });
  }
}
