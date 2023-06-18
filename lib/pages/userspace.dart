import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../tool/userspacemodel.dart';
import '../widget/spaceinfo.dart';

class UserSpace extends StatelessWidget {
  const UserSpace({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserSpaceArgs;
    return Scaffold(
      appBar: AppBar(
        title: const Text("用户资料"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: UserSpaceCont(args: args),
      ),
    );
  }
}

class UserSpaceCont extends StatelessWidget {
  final UserSpaceArgs args;
  const UserSpaceCont({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          alignment: Alignment.center,
          child: CachedNetworkImage(
            imageUrl: args.avatar,
            width: 128,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) =>
                Image.asset("assets/noavatar_big.gif"),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
          alignment: Alignment.center,
          child: SelectableText(args.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              )),
        ),
        SpaceInfo(
          args: args,
        ),
      ],
    );
  }
}
