import 'package:dartz/dartz.dart';
import 'package:learning_app_flutter/domain/entities/failures.dart';
import 'package:learning_app_flutter/domain/repositories/auth_repository.dart';

/// Use case для повторной отправки письма с подтверждением email
class ResendVerificationEmailUseCase {
  final AuthRepository _authRepository;

  ResendVerificationEmailUseCase(this._authRepository);

  /// Отправка повторного письма для подтверждения email
  /// 
  /// [email] - Email пользователя
  /// 
  /// Возвращает [Right(Unit)] в случае успеха или [Left(Failure)] в случае ошибки
  Future<Either<Failure, Unit>> execute(String email) async {
    if (email.isEmpty || !_isValidEmail(email)) {
      return left(const Failure.validation('Некорректный email'));
    }
    
    return await _authRepository.resendVerificationEmail(email);
  }

  /// Проверка валидности email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
} 