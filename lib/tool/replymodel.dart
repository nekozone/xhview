class ReplyArgs {
  final int fid;
  final int tid;
  late int? pid;
  ReplyArgs(this.fid, this.tid, this.pid);
}

class PicInfo {
  late String name;
  late String url;
  late String id;
  late String attachstr;
  PicInfo(this.name, this.url, this.id, this.attachstr);
}

class PostthreadArgs {
  final int fid;
  final String name;
  PostthreadArgs(this.fid, this.name);
}
