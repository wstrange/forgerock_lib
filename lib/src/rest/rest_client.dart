import 'package:dio/dio.dart';
import 'package:forgerock_lib/forgerock_lib.dart';
import 'package:logging/logging.dart';

class FRException implements Exception {
  String _message;
  int _code;
  FRException(String _message,[int _code = 0]);

  @override
  String toString() => 'ForgeRock REST Exception: $_message  code=$_code';
}

abstract class RESTClient {
  final Dio _dio;
  static final log = Logger('RESTClient');
  final PlatformConfig _config;

  PlatformConfig get config => _config;

  Dio get dio => _dio;

  RESTClient(this._config) : _dio = Dio() {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  // Check the response. If the response is not OK (>= 400) throw an error
  void checkOK(Response r) {
    if (r.statusCode >= 400) {
      var msg = 'Response error=${r.statusCode} msg=${r.statusMessage}';
      log.info(msg);
      throw FRException(msg,r.statusCode);
    }
  }

  void close() => dio.close();
}
