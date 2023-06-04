import 'dart:io';

import 'package:XhView/main.dart';
import 'package:flutter/material.dart';
import '../tool/profile.dart';

class Chouti extends StatelessWidget {
  const Chouti({Key? key, this.page = 'home'})
      : super(
          key: key,
        );
  final String page;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: <Widget>[
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: InkWell(
              onTap: !UserProfiles.isLogin
                  ? () {
                      Navigator.pushNamed(context, '/login');
                    }
                  : null,
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text("XhView",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      child: Image.asset("assets/404.png"),
                      // child: CachedNetworkImage(
                      //   imageUrl: Doghouse.avatarurl,
                      //   progressIndicatorBuilder:
                      //       (context, url, downloadProgress) =>
                      //           CircularProgressIndicator(
                      //               value: downloadProgress.progress),
                      //   errorWidget: (context, url, error) =>
                      //       Image.asset("assets/404.png"),
                      // ),
                    ),
                  ))
                ],
              )),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
            if (page != 'home') {
              Navigator.pushNamed(context, '/home');
            }
            // Navigator.pushNamed(context, '/home');
            // Navigator.pop(context);
          },
        ),
        ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Post'),
            onTap: () {
              Navigator.pop(context);
              if (page != 'add') {
                Navigator.pushNamed(context, '/add');
              }
            }
            // Navigator.pushNamed(context, '/add');
            // Navigator.pop(context);
            ),
        ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              if (page != 'settings') {
                Navigator.pushNamed(context, '/settings');
              }
            }
            // Navigator.pushNamed(context, '/add');
            // Navigator.pop(context);
            ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () {
            Navigator.pop(context);
            if (page != 'about') {
              Navigator.pushNamed(context, '/about');
            }
            // Navigator.pushNamed(context, '/about');
            // Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('退出'),
          onTap: () {
            // Navigator.pushNamed(context, '/about');
            // Navigator.pop(context);
            exit(0);
          },
        )
      ]),
    );

    // return Container();
  }
}
