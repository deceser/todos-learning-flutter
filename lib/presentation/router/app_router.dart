import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app_flutter/domain/entities/user.dart';
import 'package:learning_app_flutter/presentation/screens/auth/email_verification_screen.dart';
import 'package:learning_app_flutter/presentation/screens/auth/forgot_password_screen.dart';
import 'package:learning_app_flutter/presentation/screens/auth/login_screen.dart';
import 'package:learning_app_flutter/presentation/screens/auth/register_screen.dart';
import 'package:learning_app_flutter/presentation/screens/auth/reset_password_screen.dart';
import 'package:learning_app_flutter/presentation/screens/home_screen.dart';
import 'package:learning_app_flutter/presentation/state/auth/auth_notifier.dart';
import 'package:learning_app_flutter/presentation/state/auth/auth_state.dart';

/// Провайдер маршрутизатора приложения
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Получаем текущий путь
      final currentPath = state.uri.path;
      
      // Маршруты, доступные без аутентификации
      final publicRoutes = [
        '/login', 
        '/register', 
        '/forgot-password', 
        '/reset-password',
      ];
      
      return authState.maybeMap(
        // Для начального состояния или загрузки ничего не делаем
        initial: (_) => null,
        loading: (_) => null,
        
        // Если пользователь аутентифицирован, но пытается открыть страницу авторизации
        authenticated: (authenticated) {
          if (publicRoutes.contains(currentPath)) {
            return '/';
          }
          return null;
        },
        
        // Если email не подтвержден
        emailVerificationRequired: (_) {
          if (currentPath != '/verify-email' && !publicRoutes.contains(currentPath)) {
            return '/verify-email';
          }
          return null;
        },
        
        // Если пользователь не аутентифицирован и пытается открыть защищенную страницу
        unauthenticated: (_) {
          if (!publicRoutes.contains(currentPath) && 
              currentPath != '/verify-email' &&
              currentPath != '/reset-password') {
            return '/login';
          }
          return null;
        },
        
        // По умолчанию не перенаправляем
        orElse: () => null,
      );
    },
    routes: [
      // Домашняя страница (защищенный маршрут)
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Маршруты аутентификации
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) {
          final email = authState.maybeMap(
            emailVerificationRequired: (state) => state.email,
            orElse: () => '',
          );
          return EmailVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return ResetPasswordScreen(token: token);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Ошибка')),
      body: Center(
        child: Text('Страница не найдена: ${state.uri}'),
      ),
    ),
  );
}); 