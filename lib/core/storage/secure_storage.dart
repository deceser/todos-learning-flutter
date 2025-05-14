import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:learning_app_flutter/domain/entities/auth_tokens.dart';
import 'package:learning_app_flutter/domain/repositories/token_storage_repository.dart';

class SecureStorageService implements TokenStorageRepository {
  final FlutterSecureStorage _storage;
  static const String _tokensKey = 'auth_tokens';

  SecureStorageService() : _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    // Преобразуем модель в JSON и сохраняем в Secure Storage
    final Map<String, dynamic> tokensJson = {
      'access_token': tokens.accessToken,
      'refresh_token': tokens.refreshToken,
      'access_token_expiry': tokens.accessTokenExpiry.toIso8601String(),
      'refresh_token_expiry': tokens.refreshTokenExpiry.toIso8601String(),
    };
    
    await _storage.write(
      key: _tokensKey,
      value: jsonEncode(tokensJson),
    );
  }

  @override
  Future<AuthTokens?> getTokens() async {
    // Получаем строку JSON из Secure Storage и преобразуем в модель
    final tokensString = await _storage.read(key: _tokensKey);
    if (tokensString == null) {
      return null;
    }
    
    try {
      final Map<String, dynamic> tokensJson = jsonDecode(tokensString);
      return AuthTokens(
        accessToken: tokensJson['access_token'],
        refreshToken: tokensJson['refresh_token'],
        accessTokenExpiry: DateTime.parse(tokensJson['access_token_expiry']),
        refreshTokenExpiry: DateTime.parse(tokensJson['refresh_token_expiry']),
      );
    } catch (e) {
      // В случае ошибки парсинга очищаем хранилище
      await clearTokens();
      return null;
    }
  }

  @override
  Future<void> clearTokens() async {
    // Удаление токенов из хранилища
    await _storage.delete(key: _tokensKey);
  }
  
  @override
  Future<bool> hasTokens() async {
    // Проверка наличия токенов в хранилище
    final tokens = await getTokens();
    return tokens != null;
  }
} 