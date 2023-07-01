import 'package:flutter/material.dart';
import '../tool/blocklist.dart';
// import '../tool/profile.dart';

class BlocklistPage extends StatefulWidget {
  const BlocklistPage({super.key});

  @override
  State<BlocklistPage> createState() => _BlocklistPageState();
}

class _BlocklistPageState extends State<BlocklistPage> {
  final List<int> buid = [];
  final List<String> bname = [];
  int contnum = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contnum = BlockList.uid.length;
    buid.addAll(BlockList.uid);
    bname.addAll(BlockList.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("屏蔽列表"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: bllist(),
        // children: [Text(UserProfiles.blocklist ? "已启用" : "未启用"), bllist()],
      ),
    );
  }

  Widget bllist() {
    return ListView.builder(
      itemCount: BlockList.uid.length + 1,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == BlockList.uid.length) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "没有更多了",
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          );
        }
        return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              _removeItem(index);
            },
            background: Container(
              alignment: const Alignment(0.9, 0),
              color: Colors.red,
              child: const Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            child: ListTile(
              title: Text(BlockList.username[index]),
              subtitle: Text(BlockList.uid[index].toString()),
            ));
      },
    );
  }

  void _removeItem(int index) {
    // BlockList.deluser(BlockList.uid[index]);
    setState(() {
      BlockList.deluser(BlockList.uid[index]);
      contnum = BlockList.uid.length;

      // buid.removeAt(index);
      // bname.removeAt(index);
    });
  }
}
