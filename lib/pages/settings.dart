import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tool/profile.dart';
import '../widget/chouti.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Chouti(page: 'settings'),
        appBar: AppBar(title: const Text("设置"), centerTitle: true),
        body: const SingleChildScrollView(
          child: SetList(),
        ));
  }
}

class SetList extends StatefulWidget {
  const SetList({super.key});

  @override
  State<SetList> createState() => _SetListState();
}

class _SetListState extends State<SetList> {
  String dkmode = "";
  final xl = Dkmodel();

  @override
  void initState() {
    // TODO: implement initState
    // String dkmode = UserProfiles.darkmode;
    super.initState();
  }

  Widget dkSet() {
    String dkstring = "";
    dkmode = UserProfiles.darkmode;
    switch (dkmode) {
      case "system":
        dkstring = "跟随系统";
        break;
      case "light":
        dkstring = "浅色";
        break;
      case "dark":
        dkstring = "深色";
        break;
      default:
        dkstring = "跟随系统";
    }
    return Column(
      children: [
        Text('夜间模式:$dkstring'),
        Row(children: [
          ElevatedButton(
              onPressed: () => changeDkmode("system"),
              child: const Text('跟随系统')),
          ElevatedButton(
              onPressed: () => changeDkmode("light"), child: const Text('浅色')),
          ElevatedButton(
              onPressed: () => changeDkmode("dark"), child: const Text('深色')),
        ])
      ],
    );
  }

  void changeDkmode(String mode) {
    setState(() {
      dkmode = mode;
      UserProfiles.setDarkmode(mode);
    });
    context.read<Dkmodel>().changemode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: dkSet(),
    );
  }
}

class Dkmodel extends ChangeNotifier {
  String dkmode = UserProfiles.darkmode;
  void changemode(String mode) {
    dkmode = mode;
    notifyListeners();
  }
}
