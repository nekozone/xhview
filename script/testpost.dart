import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';

// final dio = Dio()..httpClientAdapter = Http2Adapter(ConnectionManager());
final dio = Dio();

void main(List<String> args) async {
  final huk = await dio.post("http://ip.dogcraft.top/45.32.27.77",
      options: Options(
          followRedirects: true,
          validateStatus: (status) {
            return status! < 500;
          }));
  print(huk.statusCode);
  print(huk.statusMessage);
  print(huk.data);
}
