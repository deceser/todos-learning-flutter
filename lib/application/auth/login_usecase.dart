import 'package:dartz/dartz.dart';
import 'package:learning_app_flutter/domain/entities/auth_tokens.dart';
import 'package:learning_app_flutter/domain/entities/failures.dart';
import 'package:learning_app_flutter/domain/repositories/auth_repository.dart';

/// Use case для авторизации пользователя
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  /// Выполнение авторизации пользователя
  /// 
  /// [email] - Email пользователя
  /// [password] - Пароль пользователя
  /// 
  /// Возвращает [Right(AuthTokens)] с токенами в случае успеха 
  /// или [Left(Failure)] в случае ошибки
  Future<Either<Failure, AuthTokens>> execute({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      return left(const Failure.validation('Email не может быть пустым'));
    }

    if (password.isEmpty) {
      return left(const Failure.validation('Пароль не может быть пустым'));
    }

    return await _authRepository.login(
      email: email,
      password: password,
    );
  }
} 