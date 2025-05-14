import 'package:dartz/dartz.dart';
import 'package:learning_app_flutter/domain/entities/failures.dart';
import 'package:learning_app_flutter/domain/repositories/auth_repository.dart';

/// Use case для подтверждения email адреса пользователя
class VerifyEmailUseCase {
  final AuthRepository _authRepository;

  VerifyEmailUseCase(this._authRepository);

  /// Выполнение подтверждения email адреса
  /// 
  /// [token] - Токен подтверждения из ссылки в письме
  /// 
  /// Возвращает [Right(Unit)] в случае успеха или [Left(Failure)] в случае ошибки
  Future<Either<Failure, Unit>> execute(String token) async {
    if (token.isEmpty) {
      return left(const Failure.validation('Токен подтверждения не может быть пустым'));
    }
    
    return await _authRepository.verifyEmail(token);
  }
}