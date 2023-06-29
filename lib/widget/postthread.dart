import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:io';
import '../tool/replymodel.dart';
import '../widget/error.dart';
import '../tool/status.dart';
import '../core/postthread.dart';
import '../core/uploadpic.dart';

class PostthreadView extends StatefulWidget {
  const PostthreadView({super.key, required this.args});
  final PostthreadArgs args;

  @override
  State<PostthreadView> createState() => _PostthreadViewState();
}

class _PostthreadViewState extends State<PostthreadView> {
  bool hasallprams = false;
  bool isposting = false;
  late Postthread postthread;
  late PostthreadArgs arg;
  Map<String, dynamic> postprame = {};
  String pichash = "";
  List<String> piclist = [];
  List<PicInfo> imglist = [];
  TextEditingController textcontmsg = TextEditingController();
  TextEditingController textcontsub = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (widget.args.pid == null) {
    //   hasallprams = true;
    // }
    _init();
  }

  void _init() async {
    arg = widget.args;
    if (XhStatus.xhstatus.isLogin) {
      postthread = Postthread(arg.fid);
      final result = await postthread.getinfo();
      if (result) {
        setState(() {
          hasallprams = true;
          postprame = postthread.postdata;
          pichash = postthread.pichash;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textcontmsg.dispose();
    textcontsub.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!XhStatus.xhstatus.isLogin) {
      return const ErrorDisplay("未登录", "aedb5f15-cedd-4863-9eb4-b92000c6d611");
    }

    return SingleChildScrollView(
      child: Column(children: [
        subinputbox(),
        msginputbox(),
        postButton(),
        piclistview()
      ]),
    );
  }

  Widget showItem() {
    final List<Widget> list = [];
    for (var item in postprame.entries) {
      list.add(ListTile(
        title: Text(item.key),
        subtitle: Text(item.value.toString()),
      ));
    }
    list.add(ListTile(
      title: const Text("pichash"),
      subtitle: Text(pichash),
    ));
    if (hasallprams) {
      list.add(ListTile(
        title: const Text("Posturl"),
        subtitle: Text(postthread.posturl),
      ));
    }
    return Column(
      children: list,
    );
  }

  Widget subinputbox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextField(
        minLines: 1,
        maxLines: 1,
        autofocus: true,
        decoration: const InputDecoration(labelText: "标题", hintText: "请输入标题"),
        controller: textcontsub,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget postButton() {
    return Container(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(height: 55),
          child: ElevatedButton.icon(
              onPressed: (!hasallprams || isposting)
                  ? null
                  : () {
                      // setState(() {
                      //   isreplying = true;
                      // });
                      _post();
                      // Future.delayed(const Duration(seconds: 3), () {
                      //   setState(() {
                      //     isreplying = false;
                      //   });
                      // });
                    },
              icon: const Icon(Icons.cloud_upload),
              label: Text((isposting) ? '发布中...' : '发布')),
        ));
  }

  void _post() {
    if (isposting) {
      return;
    }
    setState(() {
      isposting = true;
    });
    if (textcontsub.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("请输入标题"),
      ));
      return;
    }
    if (textcontmsg.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("请输入内容"),
      ));
      return;
    }
    if (imglist.isNotEmpty) {
      for (var item in imglist) {
        postthread.postdata[item.attachstr] = '';
      }
    }
    postthread.sub = textcontsub.text;
    postthread.msg = textcontmsg.text;
    postthread.execpost().then((result) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("发布成功"),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error\n${postthread.errinfo}}"),
        ));
        setState(() {
          isposting = false;
        });
      }
    });
  }

  Widget msginputbox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextField(
        minLines: 5,
        maxLines: null,
        // autofocus: true,
        decoration: const InputDecoration(labelText: "内容", hintText: "请输入内容"),
        controller: textcontmsg,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.send,
      ),
    );
  }

  Widget piclistview() {
    List<Widget> piclistview = [];
    for (var item in imglist) {
      final xk = Container(
        height: 80,
        width: 70,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColorDark,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: Stack(fit: StackFit.expand, children: [
          CachedNetworkImage(
            imageUrl: item.url,
            fit: BoxFit.contain,
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            ),
            errorWidget: (context, url, error) => Image.asset("assets/404.png"),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  delpostpic(item.id).then((res) {
                    if (res) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Remove Success"),
                      ));
                      setState(() {
                        imglist.remove(item);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("NetWork Error"),
                      ));
                      setState(() {
                        imglist.remove(item);
                      });
                    }
                  });
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ))
        ]),
      );
      piclistview.add(xk);
    }
    return Column(children: [Wrap(children: piclistview), addpicbutton()]);
  }

  Widget addpicbutton() {
    return Container(
        padding: const EdgeInsets.all(5),
        child: TextButton.icon(
          onPressed: () async {
            pickpics();
          },
          icon: const Icon(Icons.add_a_photo),
          label: const Text("添加图片"),
        ));
  }

  void pickpics() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var item in images) {
        final arg = UploadArgs(XhStatus.xhstatus.userinfo.uid, pichash, item);
        uploadpic(arg).then((res) {
          if (res.status) {
            imglist
                .add(PicInfo(res.filename, res.url, res.fileid, res.attachstr));
            setState(() {});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(res.msg),
            ));
          }
        });
      }
    }
  }
}
