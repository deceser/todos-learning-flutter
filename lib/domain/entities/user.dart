import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String username,
    required bool emailVerified,
    String? firstName,
    String? lastName,
    String? profileImageUrl,
    @Default([]) List<String> roles,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;
} 