import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app_flutter/application/auth/change_password_usecase.dart';
import 'package:learning_app_flutter/application/auth/forgot_password_usecase.dart';
import 'package:learning_app_flutter/application/auth/get_current_user_usecase.dart';
import 'package:learning_app_flutter/application/auth/login_usecase.dart';
import 'package:learning_app_flutter/application/auth/logout_usecase.dart';
import 'package:learning_app_flutter/application/auth/register_usecase.dart';
import 'package:learning_app_flutter/application/auth/resend_verification_email_usecase.dart';
import 'package:learning_app_flutter/application/auth/reset_password_usecase.dart';
import 'package:learning_app_flutter/application/auth/verify_email_usecase.dart';
import 'package:learning_app_flutter/core/network/dio_client.dart';
import 'package:learning_app_flutter/core/network/token_interceptor.dart';
import 'package:learning_app_flutter/core/storage/secure_storage.dart';
import 'package:learning_app_flutter/data/auth/auth_api_service.dart';
import 'package:learning_app_flutter/data/auth/auth_repository_impl.dart';
import 'package:learning_app_flutter/domain/repositories/auth_repository.dart';
import 'package:learning_app_flutter/domain/repositories/token_storage_repository.dart';

// Базовый URL для API
const String apiBaseUrl = 'https://api.example.com';

/// Провайдер для Secure Storage
final tokenStorageRepositoryProvider = Provider<TokenStorageRepository>((ref) {
  return SecureStorageService();
});

/// Провайдер для Dio клиента
final dioClientProvider = Provider<DioClient>((ref) {
  final tokenStorage = ref.watch(tokenStorageRepositoryProvider);
  final dioClient = DioClient(baseUrl: apiBaseUrl);
  
  // Добавляем интерцептор для работы с токенами
  final tokenInterceptor = TokenInterceptor(
    tokenStorage: tokenStorage,
    baseUrl: apiBaseUrl,
    refreshUrl: '/api/auth/refresh',
  );
  
  dioClient.addInterceptor(tokenInterceptor);
  return dioClient;
});

/// Провайдер для API сервиса авторизации
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return AuthApiService(dio, baseUrl: apiBaseUrl);
});

/// Провайдер для репозитория авторизации
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    apiService: ref.watch(authApiServiceProvider),
    tokenStorage: ref.watch(tokenStorageRepositoryProvider),
  );
});

/// Провайдеры для Use Cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) => 
  LoginUseCase(ref.watch(authRepositoryProvider)));

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) => 
  RegisterUseCase(ref.watch(authRepositoryProvider)));

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) => 
  LogoutUseCase(ref.watch(authRepositoryProvider)));

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) => 
  GetCurrentUserUseCase(ref.watch(authRepositoryProvider)));

final verifyEmailUseCaseProvider = Provider<VerifyEmailUseCase>((ref) => 
  VerifyEmailUseCase(ref.watch(authRepositoryProvider)));

final resendVerificationEmailUseCaseProvider = Provider<ResendVerificationEmailUseCase>((ref) => 
  ResendVerificationEmailUseCase(ref.watch(authRepositoryProvider)));

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) => 
  ForgotPasswordUseCase(ref.watch(authRepositoryProvider)));

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) => 
  ResetPasswordUseCase(ref.watch(authRepositoryProvider)));

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) => 
  ChangePasswordUseCase(ref.watch(authRepositoryProvider))); 