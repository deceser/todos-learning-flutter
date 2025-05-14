import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learning_app_flutter/presentation/state/auth/auth_notifier.dart';
import 'package:learning_app_flutter/presentation/state/auth/auth_state.dart';
import 'package:learning_app_flutter/presentation/widgets/app_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    
    // Получаем данные пользователя из состояния
    final user = authState.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );
    
    // Функция логаута
    void logout() {
      ref.read(authNotifierProvider.notifier).logout();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Заголовок приветствия
              Text(
                'Добро пожаловать,',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              
              const SizedBox(height: 8),
              
              // Имя пользователя
              Text(
                user?.username ?? 'Пользователь',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Информация о пользователе
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    // Email
                    _buildInfoRow(
                      context,
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user?.email ?? 'Нет данных',
                    ),
                    
                    const Divider(height: 24),
                    
                    // Статус верификации
                    _buildInfoRow(
                      context,
                      icon: user?.emailVerified == true 
                        ? Icons.verified_outlined 
                        : Icons.warning_amber_outlined,
                      label: 'Статус Email',
                      value: user?.emailVerified == true 
                        ? 'Подтвержден' 
                        : 'Не подтвержден',
                      valueColor: user?.emailVerified == true 
                        ? Colors.green 
                        : Colors.orange,
                    ),
                    
                    if (user?.firstName != null || user?.lastName != null) ...[
                      const Divider(height: 24),
                      
                      // Полное имя
                      _buildInfoRow(
                        context,
                        icon: Icons.person_outline,
                        label: 'Имя',
                        value: [
                          user?.firstName,
                          user?.lastName,
                        ].where((e) => e != null).join(' '),
                      ),
                    ],
                    
                    const Divider(height: 24),
                    
                    // Дата регистрации
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: 'Дата регистрации',
                      value: user?.createdAt != null 
                        ? '${user!.createdAt.day}.${user.createdAt.month}.${user.createdAt.year}' 
                        : 'Нет данных',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Кнопка выхода
              AppButton(
                text: 'Выйти из аккаунта',
                onPressed: logout,
                isOutlined: true,
                width: double.infinity,
                color: Colors.red,
                textColor: Colors.red,
                icon: const Icon(Icons.logout, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Построение строки с информацией о пользователе
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
} 