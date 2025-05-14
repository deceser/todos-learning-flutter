import 'package:dartz/dartz.dart';
import 'package:learning_app_flutter/domain/entities/auth_tokens.dart';
import 'package:learning_app_flutter/domain/entities/failures.dart';
import 'package:learning_app_flutter/domain/entities/user.dart';

abstract class AuthRepository {
  /// Регистрация нового пользователя
  Future<Either<Failure, Unit>> register({
    required String email,
    required String username,
    required String password,
  });

  /// Авторизация пользователя
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  });

  /// Выход из системы
  Future<Either<Failure, Unit>> logout();

  /// Обновление токена
  Future<Either<Failure, AuthTokens>> refreshToken(String refreshToken);

  /// Запрос на подтверждение email
  Future<Either<Failure, Unit>> verifyEmail(String token);

  /// Повторная отправка письма для подтверждения email
  Future<Either<Failure, Unit>> resendVerificationEmail(String email);

  /// Запрос на восстановление пароля
  Future<Either<Failure, Unit>> forgotPassword(String email);

  /// Сброс пароля
  Future<Either<Failure, Unit>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Изменение пароля
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Получение текущего пользователя
  Future<Either<Failure, User>> getCurrentUser();
} 