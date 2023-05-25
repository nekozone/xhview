import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:html/parser.dart';

final dio = Dio()..httpClientAdapter = Http2Adapter(ConnectionManager());
Future<String> getPeople() async {
  final res = await dio.get(
      "https://bbs.dippstar.com/forum.php?forumlist=1&mobile=no&mobile=1&simpletype=no");
  // print(res);
  final document = parse(res.data);
  var Restr = "";
  final elements = document.getElementsByClassName("box");
  for (var element in elements) {
    Restr += element.text;
    // print("$rawText\n\n");
  }
  return Restr;
}
