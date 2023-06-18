import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import '../tool/profile.dart';
import '../tool/status.dart';
import '../tool/userspacemodel.dart';

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
                onTap: () {
                  if (XhStatus.xhstatus.isLogin) {
                    final userargs = UserSpaceArgs(
                        uid: XhStatus.xhstatus.userinfo.uid,
                        name: XhStatus.xhstatus.userinfo.username,
                        avatar: XhStatus.xhstatus.userinfo.avatar.toString());
                    Navigator.pushNamed(context, '/userspace',
                        arguments: userargs);
                  } else {
                    Navigator.pushNamed(context, '/login');
                  }
                },
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ClipOval(
                        child: XhStatus.xhstatus.isLogin
                            ? CachedNetworkImage(
                                imageUrl: XhStatus.xhstatus.userinfo.avatar
                                    .toString(),
                                width: 80,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Image.asset("assets/noavatar_big.gif"),
                              )
                            : Image.asset(
                                "assets/noavatar_big.gif",
                                width: 80,
                              ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 45, left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                XhStatus.xhstatus.isLogin
                                    ? XhStatus.xhstatus.userinfo.username
                                    : '游客',
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.fontSize,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                XhStatus.xhstatus.isLogin
                                    ? XhStatus.xhstatus.userinfo.uid.toString()
                                    : "",
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.fontSize,
                                ))
                          ],
                        )),
                  ],
                ))

            // Column(
            //   children: [
            //     const Padding(
            //         padding: EdgeInsets.only(top: 5),
            //         child: Text("XhView",
            //             style: TextStyle(
            //                 fontSize: 30, fontWeight: FontWeight.bold))),
            //     Expanded(
            //         child: Container(
            //       padding: const EdgeInsets.all(20),
            //       child: ClipRRect(
            //         borderRadius: const BorderRadius.all(Radius.circular(40)),
            //         child: Image.asset("assets/404.svg"),
            //         // child: CachedNetworkImage(
            //         //   imageUrl: Doghouse.avatarurl,
            //         //   progressIndicatorBuilder:
            //         //       (context, url, downloadProgress) =>
            //         //           CircularProgressIndicator(
            //         //               value: downloadProgress.progress),
            //         //   errorWidget: (context, url, error) =>
            //         //       Image.asset("assets/404.svg"),
            //         // ),
            //       ),
            //     ))
            //   ],
            // )),
            ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('首页'),
          onTap: () {
            Navigator.pop(context);
            if (page != 'home') {
              Navigator.pushNamed(context, '/home');
            }
            // Navigator.pushNamed(context, '/home');
            // Navigator.pop(context);
          },
        ),
        // ListTile(
        //     leading: const Icon(Icons.add),
        //     title: const Text('Post'),
        //     onTap: () {
        //       Navigator.pop(context);
        //       if (page != 'add') {
        //         Navigator.pushNamed(context, '/add');
        //       }
        //     }
        //     // Navigator.pushNamed(context, '/add');
        //     // Navigator.pop(context);
        //     ),
        ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('设置'),
            onTap: () {
              Navigator.pop(context);
              if (page != 'settings') {
                Navigator.pushNamed(context, '/settings');
              }
            }),
        // ListTile(
        //   leading: const Icon(Icons.info),
        //   title: const Text('About'),
        //   onTap: () {
        //     Navigator.pop(context);
        //     if (page != 'about') {
        //       Navigator.pushNamed(context, '/about');
        //     }
        //     // Navigator.pushNamed(context, '/about');
        //     // Navigator.pop(context);
        //   },
        // ),
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
