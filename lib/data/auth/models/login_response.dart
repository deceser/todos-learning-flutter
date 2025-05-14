import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_app_flutter/data/auth/models/auth_tokens_dto.dart';
import 'package:learning_app_flutter/data/auth/models/user_dto.dart';
import 'package:learning_app_flutter/domain/entities/auth_tokens.dart';
import 'package:learning_app_flutter/domain/entities/user.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required UserDto user,
    @JsonKey(name: 'tokens') required AuthTokensDto tokensDto,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => 
    _$LoginResponseFromJson(json);
    
  /// Преобразование DTO в доменные сущности
  const LoginResponse._();
  
  User get userDomain => user.toDomain();
  AuthTokens get tokensDomain => tokensDto.toDomain();
} 