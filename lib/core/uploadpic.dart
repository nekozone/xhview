import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../network/connect.dart';

const resinfomap = {
  '-1': '内部服务器错误',
  '0': '上传成功',
  '1': '不支持此类扩展名',
  '2': '服务器限制无法上传那么大的附件',
  '3': '用户组限制无法上传那么大的附件',
  '4': '不支持此类扩展名',
  '5': '文件类型限制无法上传那么大的附件',
  '6': '今日您已无法上传更多的附件',
  '7': '不支持此类扩展名',
  '8': '附件文件无法保存',
  '9': '没有合法的文件被上传',
  '10': '非法操作',
  '11': '今日您已无法上传那么大的附件'
};

class UploadRes {
  late bool status;
  late String msg;
  late String url;
  late String filename;
  late String fileid;
  late String attachstr;
}

class UploadArgs {
  late int uid;
  late String pichash;
  late XFile file;
  UploadArgs(this.uid, this.pichash, this.file);
}

Future<UploadRes> uploadpic(UploadArgs args) async {
  final pname = args.file.name.split('.').last;
  final nowdatatime = DateTime.now();
  final fnm = "Xhview_upload_${nowdatatime.microsecondsSinceEpoch}.$pname";
  final updata = await MultipartFile.fromFile(args.file.path, filename: fnm);
  // final updata = await MultipartFile.fromBytes(await args.file.readAsBytes(),
  //     filename: fnm);
  final uploadform = {
    "uid": args.uid,
    "hash": args.pichash,
    "Filedata": updata
  };
  final res = await NetWorkRequest.post(
      "https://bbs.dippstar.com/misc.php?mod=swfupload&operation=upload&type=image&inajax=yes&infloat=yes&simple=2",
      formdata: uploadform);
  final uploadres = UploadRes();
  if (res.code != 200 || res.data == '') {
    uploadres.status = false;
    uploadres.msg = "Network Error";
    return uploadres;
  }
  final resdata = res.data;
  final resliststr = resdata.split("|");
  // print(resliststr);
  if (resliststr[0] == "DISCUZUPLOAD" && resliststr[2] == '0') {
    uploadres.status = true;
    uploadres.msg = resinfomap[resliststr[2]]!;
    uploadres.url =
        "https://bbs.dippstar.com/data/attachment/forum/${resliststr[5]}";
    uploadres.filename = resliststr[6];
    uploadres.fileid = resliststr[3];
    uploadres.attachstr = "attachnew[${resliststr[3]}][description]";
    return uploadres;
  }
  uploadres.status = false;
  var attstr = '';
  if (resliststr[7] == 'ban') {
    attstr = "(附件类型被禁止)";
  } else if (resliststr[7] == 'perday') {
    attstr = "(不能超过${resliststr[8]}字节)";
  } else {
    attstr = "";
  }
  uploadres.msg = resinfomap[resliststr[2]]! + attstr;
  return uploadres;
}

Future<bool> delpostpic(String fileid) async {
  final url =
      "https://bbs.dippstar.com/forum.php?mod=ajax&action=deleteattach&inajax=yes&aids[]=$fileid";
  final res = await NetWorkRequest.post(url);
  if (res.code != 200) {
    return false;
  }
  return true;
}
