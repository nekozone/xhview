import '../network/connect.dart';

class Reply {
  late int fid;
  late int tid;
  late int? pid;
  late String msg;
  final Map<String, String> postdata = {};
  Reply(this.fid, this.tid, this.pid);

  Future<bool> getinfo() async {
    if (pid == null) {}

    return true;
  }
}
