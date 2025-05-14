import 'package:dio/dio.dart';
import 'package:learning_app_flutter/domain/entities/auth_tokens.dart';
import 'package:learning_app_flutter/domain/repositories/token_storage_repository.dart';

/// Интерцептор для добавления токена авторизации к запросам
/// и автоматического обновления при истечении срока действия
class TokenInterceptor extends Interceptor {
  final TokenStorageRepository _tokenStorage;
  final Dio _refreshDio;
  final String refreshUrl;
  bool _isRefreshing = false;
  
  // Храним ожидающие запросы при обновлении токена
  final List<RequestOptions> _pendingRequests = [];

  TokenInterceptor({
    required TokenStorageRepository tokenStorage,
    required String baseUrl,
    required this.refreshUrl,
  }) : _tokenStorage = tokenStorage,
       _refreshDio = Dio(BaseOptions(
         baseUrl: baseUrl,
         headers: {
           'Content-Type': 'application/json',
           'Accept': 'application/json',
         },
       ));

  @override
  void onRequest(
    RequestOptions options, 
    RequestInterceptorHandler handler,
  ) async {
    // Пропускаем запросы на авторизацию или обновление токена
    if (options.path.contains('login') || 
        options.path.contains('register') ||
        options.path == refreshUrl) {
      return handler.next(options);
    }

    // Получаем токены из хранилища
    final tokens = await _tokenStorage.getTokens();
    if (tokens == null) {
      return handler.next(options);
    }

    // Проверяем срок действия токена
    if (tokens.isAccessTokenExpired) {
      if (tokens.isRefreshTokenExpired) {
        // Если refresh токен истек, отправляем пользователя на авторизацию
        await _tokenStorage.clearTokens();
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'Срок действия токена истек. Пожалуйста, войдите снова.',
            type: DioExceptionType.badResponse,
          ),
        );
      }

      // Обновляем токен, если уже не в процессе
      if (!_isRefreshing) {
        await _refreshToken(tokens.refreshToken);
      }
      
      // Сохраняем запрос для повторного выполнения
      _pendingRequests.add(options);
      return;
    }

    // Добавляем токен к заголовкам
    options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Если ошибка 401 Unauthorized и не запрос на обновление токена
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != refreshUrl) {
      final tokens = await _tokenStorage.getTokens();
      
      if (tokens != null && !tokens.isRefreshTokenExpired) {
        // Сохраняем запрос для повторного выполнения
        _pendingRequests.add(err.requestOptions);
        
        // Обновляем токен, если не в процессе
        if (!_isRefreshing) {
          await _refreshToken(tokens.refreshToken);
        }
        return;
      }
    }
    return handler.next(err);
  }

  /// Обновление токена и повторное выполнение ожидающих запросов
  Future<void> _refreshToken(String refreshToken) async {
    _isRefreshing = true;
    
    try {
      final response = await _refreshDio.post(
        refreshUrl,
        data: {'refresh_token': refreshToken},
      );
      
      // Парсим ответ в модель токенов
      final Map<String, dynamic> data = response.data;
      final newTokens = AuthTokens(
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
        accessTokenExpiry: DateTime.parse(data['access_token_expiry']),
        refreshTokenExpiry: DateTime.parse(data['refresh_token_expiry']),
      );
      
      // Сохраняем новые токены
      await _tokenStorage.saveTokens(newTokens);
      
      // Повторяем отложенные запросы с новым токеном
      for (final request in _pendingRequests) {
        request.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
        await _refreshDio.fetch(request);
      }
      
      _pendingRequests.clear();
    } catch (e) {
      // При ошибке очищаем токены и отменяем ожидающие запросы
      await _tokenStorage.clearTokens();
      for (final request in _pendingRequests) {
        // Отклоняем запросы с ошибкой
        // ignore: todo
        // TODO: Dispatch logout event here
      }
      _pendingRequests.clear();
    } finally {
      _isRefreshing = false;
    }
  }
} 