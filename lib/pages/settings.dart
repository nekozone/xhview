import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tool/profile.dart';
import '../widget/chouti.dart';
import '../widget/infolist.dart';
// import '../widget/cookiesview.dart';

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
    ThemeData themeData = Theme.of(context);
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
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            '夜间模式:$dkstring',
            style: TextStyle(
              fontSize: themeData.textTheme.titleMedium?.fontSize,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton.icon(
                onPressed: () => changeDkmode("system"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: dkmode == "system"
                        ? themeData.primaryColorDark
                        : themeData.primaryColorLight),
                icon: const Icon(Icons.settings_display),
                label: const Text('跟随系统')),
            ElevatedButton.icon(
                onPressed: () => changeDkmode("light"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: dkmode == "light"
                        ? themeData.primaryColorDark
                        : themeData.primaryColorLight),
                icon: const Icon(Icons.wb_sunny),
                label: const Text('浅色')),
            ElevatedButton.icon(
                onPressed: () => changeDkmode("dark"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: dkmode == "dark"
                        ? themeData.primaryColorDark
                        : themeData.primaryColorLight),
                icon: const Icon(Icons.dark_mode_sharp),
                label: const Text('深色')),
          ])
        ],
      ),
    );
  }

  void changeDkmode(String mode) {
    setState(() {
      if (dkmode == mode) {
        return;
      }
      dkmode = mode;
      UserProfiles.setDarkmode(mode);
    });
    context.read<Dkmodel>().changemode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [dkSet(), const InfoList()]);
  }
}

class Dkmodel extends ChangeNotifier {
  String dkmode = UserProfiles.darkmode;
  void changemode(String mode) {
    dkmode = mode;
    notifyListeners();
  }
}
