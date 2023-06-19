import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String errorinfo;
  final String errorcode;

  const ErrorDisplay(this.errorinfo, this.errorcode, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/404.png"),
              SelectableText(
                errorinfo,
                style: const TextStyle(fontSize: 20),
              ),
              SelectableText(
                '错误代码：$errorcode',
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ));
  }
}
