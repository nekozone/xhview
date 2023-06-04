import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../tool/profile.dart';

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

class NetWorkRequest {
  static late Dio dio;
  static late PersistCookieJar jar;

  static init() {
    print("NetWorkRequest init Start");
    dio = Dio()..httpClientAdapter = Http2Adapter(ConnectionManager());
    jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("${UserProfiles.appDocDir.path}/.cookies/"),
    );
    dio.interceptors.add(CookieManager(jar));
  }

  static Future<ReturnData> getHtml(
    String url,
  ) async {
    final returndata = ReturnData();
    final res = await dio.get(url, options: options);
    returndata.data = res.data;
    returndata.code = res.statusCode!;
    return returndata;
  }
}
