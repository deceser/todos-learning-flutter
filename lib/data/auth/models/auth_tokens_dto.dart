import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_app_flutter/domain/entities/auth_tokens.dart';

part 'auth_tokens_dto.freezed.dart';
part 'auth_tokens_dto.g.dart';

@freezed
class AuthTokensDto with _$AuthTokensDto {
  const factory AuthTokensDto({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'access_token_expiry') required String accessTokenExpiryStr,
    @JsonKey(name: 'refresh_token_expiry') required String refreshTokenExpiryStr,
  }) = _AuthTokensDto;

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) => 
    _$AuthTokensDtoFromJson(json);

  /// Преобразование DTO в доменную сущность
  const AuthTokensDto._();

  AuthTokens toDomain() {
    final accessTokenExpiry = DateTime.parse(accessTokenExpiryStr);
    final refreshTokenExpiry = DateTime.parse(refreshTokenExpiryStr);

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiry: accessTokenExpiry,
      refreshTokenExpiry: refreshTokenExpiry,
    );
  }
} 