import 'package:dio/dio.dart';
import 'dart:developer';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  )..interceptors.addAll([
    LogInterceptor(requestBody: true,responseBody: true),
  ]); // ✅ Only one formatter




  static Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      _printCurl('GET', endpoint, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      _printCurl('POST', endpoint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static void _printCurl(String method, String endpoint, Map<String, dynamic>? data) {
    final buffer = StringBuffer('curl -X $method "${_dio.options.baseUrl}$endpoint"');
    if (data != null && data.isNotEmpty) {
      buffer.write(' -d ');
      buffer.write("'${data.toString()}'");
    }
    log(buffer.toString());
  }
}
