import 'package:dartz/dartz.dart';
import 'package:learning_app_flutter/domain/entities/failures.dart';
import 'package:learning_app_flutter/domain/repositories/auth_repository.dart';

/// Use case для выхода пользователя из системы
class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  /// Выполнение выхода пользователя из системы
  /// 
  /// Возвращает [Right(Unit)] в случае успеха или [Left(Failure)] в случае ошибки
  Future<Either<Failure, Unit>> execute() async {
    return await _authRepository.logout();
  }
} 