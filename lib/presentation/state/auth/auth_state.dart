import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_app_flutter/domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// Состояние аутентификации пользователя
@freezed
class AuthState with _$AuthState {
  /// Начальное состояние (определение статуса аутентификации)
  const factory AuthState.initial() = _Initial;
  
  /// Загрузка данных
  const factory AuthState.loading() = _Loading;
  
  /// Пользователь аутентифицирован
  const factory AuthState.authenticated(User user) = _Authenticated;
  
  /// Пользователь не аутентифицирован
  const factory AuthState.unauthenticated() = _Unauthenticated;
  
  /// Email не подтвержден
  const factory AuthState.emailVerificationRequired(String email) = _EmailVerificationRequired;
  
  /// Ошибка аутентификации
  const factory AuthState.error(String message) = _Error;
} 