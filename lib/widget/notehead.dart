import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NoteHead extends StatelessWidget {
  final String username;
  final String avatar;
  final String time;
  final int lou;
  final int pid;
  final int uid;

  const NoteHead(
      {super.key,
      required this.username,
      required this.avatar,
      required this.time,
      required this.lou,
      required this.pid,
      required this.uid});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //TODO: 点击头像
        // print("点击了头像");
      },
      child: SizedBox(
        height: 80,
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: CachedNetworkImage(
                imageUrl: avatar,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/404.png"),
              ),
            ),
            Positioned(
              top: 10,
              left: 90,
              child: Text(
                username,
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
                top: 40,
                left: 90,
                height: 20,
                child: Text(time.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColorDark,
                    ))),
            Positioned(
              top: 10,
              right: 10,
              child: Text("$lou楼",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColorDark,
                  )),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Text("#${pid}"),
            )
          ],
        ),
      ),
    );
  }
}
