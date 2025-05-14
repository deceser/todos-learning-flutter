import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Базовый HTTP-клиент для запросов к API
class DioClient {
  final String baseUrl;
  final Dio _dio;

  DioClient({required this.baseUrl}) : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.sendTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Логирование запросов только в режиме разработки
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  /// Добавление интерцептора
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// Геттер для доступа к Dio
  Dio get dio => _dio;
} 