import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';

final dio = Dio()..httpClientAdapter = Http2Adapter(ConnectionManager());

Options options = Options(
  headers: {
    "User-Agent":
        "Mozilla/5.0 (Linux; Android 10; Redmi K30 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.210 Mobile Safari/537.36 XhView",
  },
);

class ReturnData {
  late int code = 0;
  late String data = "";
}

Future<ReturnData> getHtml(
  String url,
) async {
  final returndata = ReturnData();
  final res = await dio.get(url, options: options);
  returndata.data = res.data;
  returndata.code = res.statusCode!;
  return returndata;
}
