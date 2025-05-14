import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app_flutter/application/auth/get_current_user_usecase.dart';
import 'package:learning_app_flutter/application/auth/login_usecase.dart';
import 'package:learning_app_flutter/application/auth/logout_usecase.dart';
import 'package:learning_app_flutter/application/auth/register_usecase.dart';
import 'package:learning_app_flutter/core/di/providers.dart';
import 'package:learning_app_flutter/domain/repositories/token_storage_repository.dart';
import 'package:learning_app_flutter/presentation/state/auth/auth_state.dart';

/// Notifier для управления состоянием аутентификации
class AuthNotifier extends StateNotifier<AuthState> {
  final TokenStorageRepository _tokenStorage;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthNotifier({
    required TokenStorageRepository tokenStorage,
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : 
    _tokenStorage = tokenStorage,
    _loginUseCase = loginUseCase,
    _registerUseCase = registerUseCase,
    _logoutUseCase = logoutUseCase,
    _getCurrentUserUseCase = getCurrentUserUseCase,
    super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  /// Проверка статуса аутентификации при запуске
  Future<void> _checkAuthStatus() async {
    state = const AuthState.loading();
    
    final hasTokens = await _tokenStorage.hasTokens();
    if (!hasTokens) {
      state = const AuthState.unauthenticated();
      return;
    }
    
    final userResult = await _getCurrentUserUseCase.execute();
    userResult.fold(
      (failure) {
        state = const AuthState.unauthenticated();
      },
      (user) {
        if (!user.emailVerified) {
          state = AuthState.emailVerificationRequired(user.email);
        } else {
          state = AuthState.authenticated(user);
        }
      },
    );
  }

  /// Регистрация нового пользователя
  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    state = const AuthState.loading();
    
    final result = await _registerUseCase.execute(
      email: email,
      username: username,
      password: password,
    );
    
    result.fold(
      (failure) {
        state = AuthState.error(failure.toString());
      },
      (_) {
        state = AuthState.emailVerificationRequired(email);
      },
    );
  }

  /// Авторизация пользователя
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    
    final result = await _loginUseCase.execute(
      email: email,
      password: password,
    );
    
    result.fold(
      (failure) {
        state = AuthState.error(failure.toString());
      },
      (_) {
        _checkAuthStatus();
      },
    );
  }

  /// Выход из системы
  Future<void> logout() async {
    state = const AuthState.loading();
    
    final result = await _logoutUseCase.execute();
    
    result.fold(
      (failure) {
        state = AuthState.error(failure.toString());
      },
      (_) {
        state = const AuthState.unauthenticated();
      },
    );
  }
}

/// Провайдер для AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    tokenStorage: ref.read(tokenStorageRepositoryProvider),
    loginUseCase: ref.read(loginUseCaseProvider),
    registerUseCase: ref.read(registerUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
    getCurrentUserUseCase: ref.read(getCurrentUserUseCaseProvider),
  );
}); 