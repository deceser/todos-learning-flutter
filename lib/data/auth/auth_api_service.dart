import 'package:dio/dio.dart';
import 'package:learning_app_flutter/data/auth/models/change_password_request.dart';
import 'package:learning_app_flutter/data/auth/models/login_request.dart';
import 'package:learning_app_flutter/data/auth/models/login_response.dart';
import 'package:learning_app_flutter/data/auth/models/register_request.dart';
import 'package:learning_app_flutter/data/auth/models/reset_password_request.dart';
import 'package:learning_app_flutter/data/auth/models/user_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

/// API-сервис для работы с аутентификацией
@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  static const String _basePath = '/api/auth';

  /// Регистрация нового пользователя
  @POST('$_basePath/register')
  Future<void> register(@Body() RegisterRequest request);

  /// Авторизация пользователя
  @POST('$_basePath/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  /// Выход пользователя из системы
  @POST('$_basePath/logout')
  Future<void> logout();

  /// Обновление токенов доступа
  @POST('$_basePath/refresh')
  Future<LoginResponse> refreshToken(@Field('refresh_token') String refreshToken);

  /// Подтверждение email адреса
  @GET('$_basePath/verify-email')
  Future<void> verifyEmail(@Query('token') String token);

  /// Повторная отправка письма для подтверждения email
  @POST('$_basePath/resend-verification')
  Future<void> resendVerificationEmail(@Field('email') String email);

  /// Запрос на восстановление пароля
  @POST('$_basePath/forgot-password')
  Future<void> forgotPassword(@Field('email') String email);

  /// Сброс пароля
  @POST('$_basePath/reset-password')
  Future<void> resetPassword(@Body() ResetPasswordRequest request);

  /// Изменение пароля
  @POST('$_basePath/change-password')
  Future<void> changePassword(@Body() ChangePasswordRequest request);

  /// Получение информации о текущем пользователе
  @GET('$_basePath/me')
  Future<UserDto> getCurrentUser();
} 