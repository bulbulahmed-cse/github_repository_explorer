import 'package:dio/dio.dart';

class NetworkClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.github.com',
    headers: {'Accept': 'application/vnd.github+json'},
  ));

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) async {
    return _dio.get<T>(path, queryParameters: query);
  }
}
