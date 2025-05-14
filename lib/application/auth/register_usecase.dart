import 'package:dartz/dartz.dart';
import 'package:learning_app_flutter/domain/entities/failures.dart';
import 'package:learning_app_flutter/domain/repositories/auth_repository.dart';

/// Use case для регистрации нового пользователя
class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  /// Выполнение регистрации пользователя
  /// 
  /// [email] - Email пользователя
  /// [username] - Имя пользователя
  /// [password] - Пароль пользователя
  /// 
  /// Возвращает [Right(unit)] в случае успеха или [Left(Failure)] в случае ошибки
  Future<Either<Failure, Unit>> execute({
    required String email,
    required String username,
    required String password,
  }) async {
    if (email.isEmpty || !_isValidEmail(email)) {
      return left(const Failure.validation('Некорректный email'));
    }

    if (username.isEmpty || username.length < 3) {
      return left(const Failure.validation(
        'Имя пользователя должно содержать минимум 3 символа',
      ));
    }

    if (password.isEmpty || !_isValidPassword(password)) {
      return left(const Failure.validation(
        'Пароль должен содержать минимум 8 символов, включая цифры и буквы',
      ));
    }

    return await _authRepository.register(
      email: email,
      username: username,
      password: password,
    );
  }

  /// Проверка валидности email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
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