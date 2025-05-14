import 'package:dartz/dartz.dart';
import 'package:learning_app_flutter/domain/entities/failures.dart';
import 'package:learning_app_flutter/domain/entities/user.dart';
import 'package:learning_app_flutter/domain/repositories/auth_repository.dart';

/// Use case для получения информации о текущем пользователе
class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  /// Получение информации о текущем пользователе
  /// 
  /// Возвращает [Right(User)] с данными пользователя в случае успеха 
  /// или [Left(Failure)] в случае ошибки
  Future<Either<Failure, User>> execute() async {
    return await _authRepository.getCurrentUser();
  }
} 