import 'package:flutter/material.dart';
import '../tool/userspacemodel.dart';
import '../tool/bbslogout.dart';
import '../core/userspace.dart';
import '../widget/error.dart';

class SpaceInfo extends StatefulWidget {
  final UserSpaceArgs args;
  const SpaceInfo({super.key, required this.args});

  @override
  State<SpaceInfo> createState() => _SpaceInfoState();
}

class _SpaceInfoState extends State<SpaceInfo> {
  late UserSpaceArgs args;
  late UserspaceInfo info;
  late dynamic _getinfo;

  bool islogouting = false;

  @override
  void initState() {
    super.initState();
    args = widget.args;
    info = UserspaceInfo(uid: args.uid);
    _getinfo = getinfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _getinfo, builder: fbuild);
  }

  Future<bool> getinfo() async {
    bool res = await info.getinfo();
    if (res) {
      info.avatar = args.avatar;
      info.username = args.name;
    }
    return res;
  }

  Widget fbuild(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return const ErrorDisplay(
            "加载失败了，有错误。", "378ba136-37f9-4acb-9cb5-bc1fe42b45c3");
      }
      final res = snapshot.data as bool;
      if (!res) {
        return const ErrorDisplay(
            "加载失败了，有错误。", "f939a675-a1be-4be4-9536-04806d2670cd");
      }
      return displayView();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget displayView() {
    List<Widget> lw = [];
    info.spaceinfo.forEach((key, value) {
      lw.add(ListTile(
          contentPadding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
          title: Text(key),
          subtitle: Text(value)));
      lw.add(const Divider(height: 1));
    });
    if (info.logouturl != null && info.logouturl != "") {
      lw.add(Container(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(height: 55),
            child: ElevatedButton.icon(
                onPressed: islogouting ? null : _onpress,
                icon: const Icon(Icons.logout),
                label: const Text("退出登录")),
          )));
    }
    return Column(children: lw);
  }

  void _onpress() {
    setState(() {
      islogouting = true;
    });
    bbslogout(info.logouturl!).then((res) {
      setState(() {
        islogouting = false;
      });
      if (res) {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      }
    });
  }
}
