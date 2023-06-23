import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../tool/profile.dart';

Options options = Options(
  headers: {
    "User-Agent":
        "Mozilla/5.0 (Linux; Android 10; Quantum 550W Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36  XhView/0.0.1",
  },
);

Options postoptions = Options(
    headers: {
      "User-Agent":
          "Mozilla/5.0 (Linux; Android 10; Quantum 550W Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36  XhView/0.0.1",
    },
    followRedirects: false,
    validateStatus: (status) {
      return status! < 500;
    });

Options pcoptions = Options(
  headers: {
    "User-Agent":
        "Mozilla/5.0 (X11; Linux x86_64; Quantum 550W Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36 XhView/0.0.1",
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
    dio = Dio()..httpClientAdapter = Http2Adapter(ConnectionManager());
    jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("${UserProfiles.appDocDir.path}/.cookies/"),
    );
    dio.interceptors.add(CookieManager(jar));
  }

  static Future<ReturnData> getHtml(String url,
      {Map<String, dynamic>? formdata}) async {
    if (formdata == null) {
      final returndata = ReturnData();
      final res = await dio.get(url, options: options);
      returndata.data = res.data;
      returndata.code = res.statusCode!;
      return returndata;
    } else {
      final returndata = ReturnData();
      final form = FormData.fromMap(formdata);
      final res = await dio.get(url, data: form, options: options);
      returndata.data = res.data;
      returndata.code = res.statusCode!;
      return returndata;
    }
  }

  static Future<ReturnData> getpcHtml(
    String url,
  ) async {
    final returndata = ReturnData();
    final res = await dio.get(url, options: pcoptions);
    returndata.data = res.data;
    returndata.code = res.statusCode!;
    return returndata;
  }

  static Future<ReturnData> post(String url,
      {Map<String, dynamic>? formdata}) async {
    if (formdata == null) {
      final returndata = ReturnData();
      final res = await dio.post(url, options: postoptions);
      returndata.data = res.data;
      returndata.code = res.statusCode!;
      return returndata;
    } else {
      final returndata = ReturnData();
      final form = FormData.fromMap(formdata);
      final res = await dio.post(url, data: form, options: postoptions);
      returndata.data = res.data ?? "";
      returndata.code = res.statusCode!;
      return returndata;
    }
  }

  static Future<ReturnData> login(String username, String password) async {
    final returndata = ReturnData();
    final formdata = FormData.fromMap({
      "fastloginfield": "username",
      "username": username,
      "cookietime": "2592000",
      "password": password,
      "quickforward": "yes",
      "handlekey": "ls",
    });
    final res = await dio.post(
      "https://bbs.dippstar.com/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1",
      data: formdata,
      options: options,
    );
    returndata.data = res.data;
    returndata.code = res.statusCode!;
    return returndata;
  }
}
