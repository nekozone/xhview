import 'package:flutter/material.dart';

class NoteFoot extends StatelessWidget {
  const NoteFoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(right: 10),
      width: double.infinity,
      // height: Theme.of(context).textTheme.bodyMedium?.fontSize,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Icon(
          Icons.reply_all,
          size: Theme.of(context).textTheme.bodyMedium?.fontSize,
          color: (Theme.of(context).brightness == Brightness.light)
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColorLight,
        )
        // size: Theme.of(context).textTheme.bodyMedium?.fontSize),
      ]),
    );
  }
}
