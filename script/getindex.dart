import 'package:dio/dio.dart';

final dio = Dio();
Future<void> main(List<String> args) async {
  print("Hello World");
  final res = await dio.get(
      "https://bbs.dippstar.com/forum.php?forumlist=1&mobile=no&mobile=1&simpletype=no");
  print(res);
}
