import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';

@freezed
class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime accessTokenExpiry,
    required DateTime refreshTokenExpiry,
  }) = _AuthTokens;

  // Метод для проверки истечения срока действия access токена
  const AuthTokens._();
  
  bool get isAccessTokenExpired => 
      DateTime.now().isAfter(accessTokenExpiry);
  
  bool get isRefreshTokenExpired => 
      DateTime.now().isAfter(refreshTokenExpiry);
} 