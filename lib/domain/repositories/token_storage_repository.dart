import 'package:learning_app_flutter/domain/entities/auth_tokens.dart';

abstract class TokenStorageRepository {
  /// Сохранение токенов в хранилище
  Future<void> saveTokens(AuthTokens tokens);

  /// Получение токенов из хранилища
  Future<AuthTokens?> getTokens();

  /// Удаление токенов из хранилища при выходе
  Future<void> clearTokens();

  /// Проверка наличия токенов в хранилище
  Future<bool> hasTokens();
} 