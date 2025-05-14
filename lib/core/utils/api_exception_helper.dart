import 'dart:io';

import 'package:dio/dio.dart';
import 'package:learning_app_flutter/domain/entities/failures.dart';

/// Вспомогательный класс для обработки исключений API и преобразования их в доменные ошибки
class ApiExceptionHelper {
  /// Преобразует исключение Dio в доменную ошибку Failure
  static Failure handleDioException(DioException exception) {
    switch (exception.type) {
      // Ошибки сети
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure.network('Превышено время ожидания соединения');
      
      // Ошибки соединения
      case DioExceptionType.connectionError:
        return const Failure.network('Проблема с подключением к сети');
      
      // Ошибки с ответами от сервера
      case DioExceptionType.badResponse:
        return _handleBadResponse(exception.response);
      
      // Ошибки отмены запроса
      case DioExceptionType.cancel:
        return const Failure.unexpected('Запрос был отменен');
      
      // Прочие ошибки Dio
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      default:
        return Failure.unexpected(
          exception.message ?? 'Произошла неизвестная ошибка',
        );
    }
  }

  /// Обрабатывает ответы с ошибками от сервера
  static Failure _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;
    
    String errorMessage = 'Произошла ошибка при обработке запроса';
    
    // Пытаемся получить сообщение об ошибке из ответа
    if (data != null && data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        errorMessage = data['message'];
      } else if (data.containsKey('error')) {
        errorMessage = data['error'];
      }
    }
    
    // Определяем тип ошибки по статус-коду
    switch (statusCode) {
      case HttpStatus.unauthorized: // 401
        return Failure.auth(errorMessage);
      
      case HttpStatus.forbidden: // 403
        return Failure.auth('Недостаточно прав для выполнения операции');
      
      case HttpStatus.notFound: // 404
        return Failure.notFound(errorMessage);
      
      case HttpStatus.unprocessableEntity: // 422
        return Failure.validation(errorMessage);
      
      case HttpStatus.internalServerError: // 500
      case HttpStatus.badGateway: // 502
      case HttpStatus.serviceUnavailable: // 503
      case HttpStatus.gatewayTimeout: // 504
        return Failure.server('Ошибка сервера. Попробуйте позже');
      
      default:
        return Failure.unexpected(errorMessage);
    }
  }

  /// Обрабатывает другие типы исключений
  static Failure handleException(Object exception) {
    if (exception is DioException) {
      return handleDioException(exception);
    } 
    
    if (exception is SocketException) {
      return const Failure.network('Не удалось подключиться к серверу');
    }
    
    if (exception is FormatException) {
      return const Failure.unexpected('Неверный формат данных');
    }
    
    return Failure.unexpected(exception.toString());
  }
} 