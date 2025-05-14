// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_tokens_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthTokensDtoImpl _$$AuthTokensDtoImplFromJson(Map<String, dynamic> json) =>
    _$AuthTokensDtoImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      accessTokenExpiryStr: json['access_token_expiry'] as String,
      refreshTokenExpiryStr: json['refresh_token_expiry'] as String,
    );

Map<String, dynamic> _$$AuthTokensDtoImplToJson(_$AuthTokensDtoImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'access_token_expiry': instance.accessTokenExpiryStr,
      'refresh_token_expiry': instance.refreshTokenExpiryStr,
    };
