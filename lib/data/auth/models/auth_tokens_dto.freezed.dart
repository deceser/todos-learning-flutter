// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_tokens_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthTokensDto _$AuthTokensDtoFromJson(Map<String, dynamic> json) {
  return _AuthTokensDto.fromJson(json);
}

/// @nodoc
mixin _$AuthTokensDto {
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'access_token_expiry')
  String get accessTokenExpiryStr => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token_expiry')
  String get refreshTokenExpiryStr => throw _privateConstructorUsedError;

  /// Serializes this AuthTokensDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthTokensDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthTokensDtoCopyWith<AuthTokensDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthTokensDtoCopyWith<$Res> {
  factory $AuthTokensDtoCopyWith(
          AuthTokensDto value, $Res Function(AuthTokensDto) then) =
      _$AuthTokensDtoCopyWithImpl<$Res, AuthTokensDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'access_token_expiry') String accessTokenExpiryStr,
      @JsonKey(name: 'refresh_token_expiry') String refreshTokenExpiryStr});
}

/// @nodoc
class _$AuthTokensDtoCopyWithImpl<$Res, $Val extends AuthTokensDto>
    implements $AuthTokensDtoCopyWith<$Res> {
  _$AuthTokensDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthTokensDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? accessTokenExpiryStr = null,
    Object? refreshTokenExpiryStr = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      accessTokenExpiryStr: null == accessTokenExpiryStr
          ? _value.accessTokenExpiryStr
          : accessTokenExpiryStr // ignore: cast_nullable_to_non_nullable
              as String,
      refreshTokenExpiryStr: null == refreshTokenExpiryStr
          ? _value.refreshTokenExpiryStr
          : refreshTokenExpiryStr // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthTokensDtoImplCopyWith<$Res>
    implements $AuthTokensDtoCopyWith<$Res> {
  factory _$$AuthTokensDtoImplCopyWith(
          _$AuthTokensDtoImpl value, $Res Function(_$AuthTokensDtoImpl) then) =
      __$$AuthTokensDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'access_token_expiry') String accessTokenExpiryStr,
      @JsonKey(name: 'refresh_token_expiry') String refreshTokenExpiryStr});
}

/// @nodoc
class __$$AuthTokensDtoImplCopyWithImpl<$Res>
    extends _$AuthTokensDtoCopyWithImpl<$Res, _$AuthTokensDtoImpl>
    implements _$$AuthTokensDtoImplCopyWith<$Res> {
  __$$AuthTokensDtoImplCopyWithImpl(
      _$AuthTokensDtoImpl _value, $Res Function(_$AuthTokensDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthTokensDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? accessTokenExpiryStr = null,
    Object? refreshTokenExpiryStr = null,
  }) {
    return _then(_$AuthTokensDtoImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      accessTokenExpiryStr: null == accessTokenExpiryStr
          ? _value.accessTokenExpiryStr
          : accessTokenExpiryStr // ignore: cast_nullable_to_non_nullable
              as String,
      refreshTokenExpiryStr: null == refreshTokenExpiryStr
          ? _value.refreshTokenExpiryStr
          : refreshTokenExpiryStr // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthTokensDtoImpl extends _AuthTokensDto {
  const _$AuthTokensDtoImpl(
      {@JsonKey(name: 'access_token') required this.accessToken,
      @JsonKey(name: 'refresh_token') required this.refreshToken,
      @JsonKey(name: 'access_token_expiry') required this.accessTokenExpiryStr,
      @JsonKey(name: 'refresh_token_expiry')
      required this.refreshTokenExpiryStr})
      : super._();

  factory _$AuthTokensDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthTokensDtoImplFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @override
  @JsonKey(name: 'access_token_expiry')
  final String accessTokenExpiryStr;
  @override
  @JsonKey(name: 'refresh_token_expiry')
  final String refreshTokenExpiryStr;

  @override
  String toString() {
    return 'AuthTokensDto(accessToken: $accessToken, refreshToken: $refreshToken, accessTokenExpiryStr: $accessTokenExpiryStr, refreshTokenExpiryStr: $refreshTokenExpiryStr)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthTokensDtoImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.accessTokenExpiryStr, accessTokenExpiryStr) ||
                other.accessTokenExpiryStr == accessTokenExpiryStr) &&
            (identical(other.refreshTokenExpiryStr, refreshTokenExpiryStr) ||
                other.refreshTokenExpiryStr == refreshTokenExpiryStr));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken,
      accessTokenExpiryStr, refreshTokenExpiryStr);

  /// Create a copy of AuthTokensDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthTokensDtoImplCopyWith<_$AuthTokensDtoImpl> get copyWith =>
      __$$AuthTokensDtoImplCopyWithImpl<_$AuthTokensDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthTokensDtoImplToJson(
      this,
    );
  }
}

abstract class _AuthTokensDto extends AuthTokensDto {
  const factory _AuthTokensDto(
      {@JsonKey(name: 'access_token') required final String accessToken,
      @JsonKey(name: 'refresh_token') required final String refreshToken,
      @JsonKey(name: 'access_token_expiry')
      required final String accessTokenExpiryStr,
      @JsonKey(name: 'refresh_token_expiry')
      required final String refreshTokenExpiryStr}) = _$AuthTokensDtoImpl;
  const _AuthTokensDto._() : super._();

  factory _AuthTokensDto.fromJson(Map<String, dynamic> json) =
      _$AuthTokensDtoImpl.fromJson;

  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;
  @override
  @JsonKey(name: 'access_token_expiry')
  String get accessTokenExpiryStr;
  @override
  @JsonKey(name: 'refresh_token_expiry')
  String get refreshTokenExpiryStr;

  /// Create a copy of AuthTokensDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthTokensDtoImplCopyWith<_$AuthTokensDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
