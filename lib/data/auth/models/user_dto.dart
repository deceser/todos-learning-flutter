import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_app_flutter/domain/entities/user.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    required String username,
    @JsonKey(name: 'email_verified') required bool emailVerified,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
    @Default([]) List<String> roles,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  /// Преобразование DTO в доменную сущность
  const UserDto._();

  User toDomain() {
    return User(
      id: id,
      email: email,
      username: username,
      emailVerified: emailVerified,
      firstName: firstName,
      lastName: lastName,
      profileImageUrl: profileImageUrl,
      roles: roles,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
} 