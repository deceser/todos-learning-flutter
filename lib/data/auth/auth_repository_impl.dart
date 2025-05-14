import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:learning_app_flutter/core/utils/api_exception_helper.dart';
import 'package:learning_app_flutter/data/auth/auth_api_service.dart';
import 'package:learning_app_flutter/data/auth/models/change_password_request.dart';
import 'package:learning_app_flutter/data/auth/models/login_request.dart';
import 'package:learning_app_flutter/data/auth/models/register_request.dart';
import 'package:learning_app_flutter/data/auth/models/reset_password_request.dart';
import 'package:learning_app_flutter/domain/entities/auth_tokens.dart';
import 'package:learning_app_flutter/domain/entities/failures.dart';
import 'package:learning_app_flutter/domain/entities/user.dart';
import 'package:learning_app_flutter/domain/repositories/auth_repository.dart';
import 'package:learning_app_flutter/domain/repositories/token_storage_repository.dart';

/// Реализация репозитория аутентификации для работы с API
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  final TokenStorageRepository _tokenStorage;

  AuthRepositoryImpl({
    required AuthApiService apiService,
    required TokenStorageRepository tokenStorage,
  }) : 
    _apiService = apiService,
    _tokenStorage = tokenStorage;

  @override
  Future<Either<Failure, Unit>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        username: username,
        password: password,
      );
      
      await _apiService.register(request);
      return right(unit);
    } catch (e) {
      return left(ApiExceptionHelper.handleException(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(
        email: email,
        password: password,
      );
      
      final response = await _apiService.login(request);
      final tokens = response.tokensDomain;
      
      // Сохраняем токены в Secure Storage
      await _tokenStorage.saveTokens(tokens);
      
      return right(tokens);
    } catch (e) {
      return left(ApiExceptionHelper.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _apiService.logout();
      
      // Очищаем токены в Secure Storage
      await _tokenStorage.clearTokens();
      
      return right(unit);
    } catch (e) {
      // Даже при ошибке API очищаем токены локально
      await _tokenStorage.clearTokens();
      
      // И возвращаем успех, т.к. локально пользователь уже разлогинен
      return right(unit);
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken(String refreshToken) async {
    try {
      final response = await _apiService.refreshToken(refreshToken);
      final tokens = response.tokensDomain;
      
      // Сохраняем обновленные токены
      await _tokenStorage.saveTokens(tokens);
      
      return right(tokens);
    } catch (e) {
      // При ошибке очищаем токены, т.к. refresh token мог быть недействительным
      await _tokenStorage.clearTokens();
      
      return left(ApiExceptionHelper.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail(String token) async {
    try {
      await _apiService.verifyEmail(token);
      return right(unit);
    } catch (e) {
      return left(ApiExceptionHelper.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> resendVerificationEmail(String email) async {
    try {
      await _apiService.resendVerificationEmail(email);
      return right(unit);
    } catch (e) {
      return left(ApiExceptionHelper.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword(String email) async {
    try {
      await _apiService.forgotPassword(email);
      return right(unit);
    } catch (e) {
      return left(ApiExceptionHelper.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final request = ResetPasswordRequest(
        token: token,
        newPassword: newPassword,
      );
      
      await _apiService.resetPassword(request);
      return right(unit);
    } catch (e) {
      return left(ApiExceptionHelper.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      await _apiService.changePassword(request);
      return right(unit);
    } catch (e) {
      return left(ApiExceptionHelper.handleException(e));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userDto = await _apiService.getCurrentUser();
      final user = userDto.toDomain();
      
      return right(user);
    } on DioException catch (e) {
      // Если ошибка 401, очищаем токены
      if (e.response?.statusCode == 401) {
        await _tokenStorage.clearTokens();
      }
      
      return left(ApiExceptionHelper.handleDioException(e));
    } catch (e) {
      return left(ApiExceptionHelper.handleException(e));
    }
  }
} 