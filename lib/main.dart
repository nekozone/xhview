import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XhView',
      home: const Home(),
      routes: {
        '/home': (context) => const Settings(),
        // '/about': (context) => const Dogabout(),
        // '/add': ((context) => const Addpage()),
        // '/settings': ((context) => const SetPage()),
      },
    );
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
      child: const Settings(),
    );
  }
}
