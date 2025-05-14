import 'package:dartz/dartz.dart';
import 'package:learning_app_flutter/domain/entities/failures.dart';
import 'package:learning_app_flutter/domain/repositories/auth_repository.dart';

/// Use case для сброса пароля
class ResetPasswordUseCase {
  final AuthRepository _authRepository;

  ResetPasswordUseCase(this._authRepository);

  /// Выполнение сброса пароля
  /// 
  /// [token] - Токен из ссылки для сброса пароля
  /// [newPassword] - Новый пароль пользователя
  /// [confirmPassword] - Подтверждение нового пароля
  /// 
  /// Возвращает [Right(Unit)] в случае успеха или [Left(Failure)] в случае ошибки
  Future<Either<Failure, Unit>> execute({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (token.isEmpty) {
      return left(const Failure.validation('Токен сброса пароля недействителен'));
    }

    if (newPassword.isEmpty || !_isValidPassword(newPassword)) {
      return left(const Failure.validation(
        'Пароль должен содержать минимум 8 символов, включая цифры и буквы',
      ));
    }

    if (newPassword != confirmPassword) {
      return left(const Failure.validation('Пароли не совпадают'));
    }

    return await _authRepository.resetPassword(
      token: token,
      newPassword: newPassword,
    );
  }

  /// Проверка валидности пароля
  bool _isValidPassword(String password) {
    // Минимум 8 символов, хотя бы одна буква и хотя бы одна цифра
    final passwordRegex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }
} 