import 'package:flutter/material.dart';
import '../widget/chouti.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Chouti(page: 'settings'),
        appBar: AppBar(title: const Text("设置"), centerTitle: true),
        body: const Center(
          child: Text("Settings"),
        ));
  }
}
