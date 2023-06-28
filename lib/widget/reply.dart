import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import '../tool/replymodel.dart';
import '../widget/error.dart';
import '../tool/status.dart';
import '../core/reply.dart';
import '../core/uploadpic.dart';

class ReplyView extends StatefulWidget {
  const ReplyView({super.key, required this.args});
  final ReplyArgs args;

  @override
  State<ReplyView> createState() => _ReplyViewState();
}

class _ReplyViewState extends State<ReplyView> {
  bool hasallprams = false;
  bool isreplying = false;
  late Reply reply;
  late ReplyArgs arg;
  Map<String, dynamic> postprame = {};
  String pichash = "";
  List<String> piclist = [];
  List<PicInfo> imglist = [];
  TextEditingController textcont = TextEditingController();
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
      reply = Reply(arg.fid, arg.tid, arg.pid);
      final result = await reply.getinfo();
      if (result) {
        setState(() {
          hasallprams = true;
          postprame = reply.postdata;
          pichash = reply.pichash;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textcont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!XhStatus.xhstatus.isLogin) {
      return const ErrorDisplay("未登录", "3dd24949-1746-499f-8801-cb2067cbbb65");
    }

    return SingleChildScrollView(
      child: Column(
          children: [showItem(), inputbox(), replyButton(), piclistview()]),
    );
  }

  Widget inputbox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextField(
        minLines: 5,
        maxLines: 100,
        autofocus: true,
        decoration: const InputDecoration(labelText: "回复内容", hintText: "请输入内容"),
        controller: textcont,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget replyButton() {
    return Container(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(height: 55),
          child: ElevatedButton.icon(
              onPressed: (!hasallprams || isreplying)
                  ? null
                  : () {
                      // setState(() {
                      //   isreplying = true;
                      // });
                      _reply();
                      // Future.delayed(const Duration(seconds: 3), () {
                      //   setState(() {
                      //     isreplying = false;
                      //   });
                      // });
                    },
              icon: const Icon(Icons.cloud_upload),
              label: Text((isreplying) ? '回复中...' : '回复')),
        ));
  }

  Widget showItem() {
    if (hasallprams) {
      if (reply.postdata["noticeauthormsg"] != null &&
          reply.postdata["noticeauthormsg"] != "") {
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColorDark,
                width: 0.5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(6))),
          child: Text(reply.postdata["noticeauthormsg"]!),
        );
      } else {
        return Container(
          padding: const EdgeInsets.only(top: 10),
          child: const Divider(
            height: 0,
          ),
        );
      }
    } else {
      return Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Divider(
          height: 0,
        ),
      );
    }
  }

  void _reply() {
    if (isreplying) {
      return;
    }
    setState(() {
      isreplying = true;
    });
    if (textcont.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("请输入内容"),
      ));
      return;
    }
    if (imglist.isNotEmpty) {
      for (var item in imglist) {
        reply.postdata[item.attachstr] = '';
      }
    }
    reply.execreply(textcont.text).then((result) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("回复成功"),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error\n${reply.errinfo}}"),
        ));
        setState(() {
          isreplying = false;
        });
      }
    });
  }

  Widget piclistviewx() {
    List<Widget> piclistview = [];
    for (var item in piclist) {
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
          Image.file(fit: BoxFit.contain, File(item)),
          Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    piclist.remove(item);
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

  void pickpicsx() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var item in images) {
        piclist.add(item.path);
      }
      setState(() {});
    }
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
