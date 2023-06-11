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
        height: 60,
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: CachedNetworkImage(
                imageUrl: avatar,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/noavatar_big.gif"),
              ),
            ),
            Positioned(
              top: 10,
              left: 60,
              child: Text(
                username,
                style: TextStyle(
                    fontSize: 16,
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? Theme.of(context).primaryColorDark
                        : Theme.of(context).primaryColorLight,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
                top: 36,
                left: 60,
                height: 20,
                child: Text(time.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                    ))),
            Positioned(
              top: 10,
              right: 10,
              child: Text("$lou楼",
                  style: const TextStyle(
                    fontSize: 12,
                  )),
            ),
            Positioned(
              top: 36,
              right: 10,
              child: Text("#$pid",
                  style: const TextStyle(
                    fontSize: 12,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
