import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/settings.dart';
import 'pages/index.dart';
import 'pages/forum.dart';
import 'tool/profile.dart';
import 'tool/status.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserProfiles.init();
  await XhStatus.init();
  runApp(const XhView());
}

class XhView extends StatelessWidget {
  const XhView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Dkmodel(),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            brightness: context.watch<Dkmodel>().dkmode == 'dark'
                ? Brightness.dark
                : context.watch<Dkmodel>().dkmode == 'light'
                    ? Brightness.light
                    : MediaQuery.of(context).platformBrightness,
          ),
          title: 'XhView',
          home: const Home(),
          routes: {
            '/home': (context) => const IndexPage(),
            '/settings': (context) => const SettingsPage(),
            '/forum': (context) => const Forum(),

            // '/about': (context) => const Dogabout(),
            // '/add': ((context) => const Addpage()),
            // '/settings': ((context) => const SetPage()),
          },
        );
      },
    );
    ;
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime? _lastPressedAt;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) >
                const Duration(seconds: 1)) {
          //两次点击间隔超过1秒则重新计时
          _lastPressedAt = DateTime.now();
          const snkb = SnackBar(content: Text("再按一次退出"));
          ScaffoldMessenger.of(context).showSnackBar(snkb);
          return false;
        }
        return true;
      },
      child: const IndexPage(),
    );
  }
}
