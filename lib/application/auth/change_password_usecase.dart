import 'package:dartz/dartz.dart';
import 'package:learning_app_flutter/domain/entities/failures.dart';
import 'package:learning_app_flutter/domain/repositories/auth_repository.dart';

/// Use case для изменения пароля пользователя
class ChangePasswordUseCase {
  final AuthRepository _authRepository;

  ChangePasswordUseCase(this._authRepository);

  /// Выполнение изменения пароля
  /// 
  /// [currentPassword] - Текущий пароль пользователя
  /// [newPassword] - Новый пароль пользователя
  /// [confirmPassword] - Подтверждение нового пароля
  /// 
  /// Возвращает [Right(Unit)] в случае успеха или [Left(Failure)] в случае ошибки
  Future<Either<Failure, Unit>> execute({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty) {
      return left(const Failure.validation('Текущий пароль не может быть пустым'));
    }

    if (newPassword.isEmpty || !_isValidPassword(newPassword)) {
      return left(const Failure.validation(
        'Пароль должен содержать минимум 8 символов, включая цифры и буквы',
      ));
    }

    if (newPassword != confirmPassword) {
      return left(const Failure.validation('Пароли не совпадают'));
    }

    if (currentPassword == newPassword) {
      return left(const Failure.validation(
        'Новый пароль должен отличаться от текущего',
      ));
    }

    return await _authRepository.changePassword(
      currentPassword: currentPassword,
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