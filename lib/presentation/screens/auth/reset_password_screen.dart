import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app_flutter/application/auth/reset_password_usecase.dart';
import 'package:learning_app_flutter/core/di/providers.dart';
import 'package:learning_app_flutter/presentation/widgets/app_button.dart';
import 'package:learning_app_flutter/presentation/widgets/app_text_field.dart';
import 'package:learning_app_flutter/presentation/widgets/auth_wrapper.dart';

class ResetPasswordScreen extends HookConsumerWidget {
  final String token;

  const ResetPasswordScreen({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controllers для текстовых полей
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    
    // Состояния показа/скрытия паролей
    final showPassword = useState(false);
    final showConfirmPassword = useState(false);
    
    // Состояние формы для валидации
    final formKey = useMemoized(() => GlobalKey<FormState>());
    
    // Состояния загрузки и успешного сброса
    final isLoading = useState(false);
    final isPasswordReset = useState(false);
    
    // Обработка пустого токена
    final isTokenEmpty = token.isEmpty;
    
    useEffect(() {
      if (isTokenEmpty) {
        // Если токен пустой, показываем сообщение об ошибке
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Недействительная ссылка'),
              content: const Text(
                'Ссылка для сброса пароля недействительна или устарела. '
                'Пожалуйста, запросите новую ссылку для сброса пароля.',
              ),
              actions: [
                TextButton(
                  onPressed: () => context.go('/forgot-password'),
                  child: const Text('Запросить новую ссылку'),
                ),
              ],
            ),
          );
        });
      }
      return null;
    }, [isTokenEmpty]);
    
    // Функция сброса пароля
    Future<void> resetPassword() async {
      if (formKey.currentState?.validate() ?? false) {
        isLoading.value = true;
        
        try {
          final newPassword = passwordController.text;
          final confirmPassword = confirmPasswordController.text;
          
          final resetPasswordUseCase = ref.read(resetPasswordUseCaseProvider);
          final result = await resetPasswordUseCase.execute(
            token: token,
            newPassword: newPassword,
            confirmPassword: confirmPassword,
          );
          
          result.fold(
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.toString()),
                  backgroundColor: Colors.red,
                ),
              );
            },
            (_) {
              isPasswordReset.value = true;
            },
          );
        } finally {
          isLoading.value = false;
        }
      }
    }
    
    if (isPasswordReset.value) {
      // Показываем экран успешного сброса пароля
      return AuthWrapper(
        title: 'Пароль изменен',
        subtitle: 'Ваш пароль был успешно изменен',
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(16),
              
              // Иконка успеха
              Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green,
              ),
              
              const Gap(24),
              
              // Описание
              Text(
                'Вы можете использовать новый пароль для входа в свой аккаунт.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              
              const Gap(32),
              
              // Кнопка перехода на экран входа
              AppButton(
                text: 'Войти',
                onPressed: () => context.go('/login'),
                width: double.infinity,
              ),
            ],
          ),
        ],
      );
    }
    
    return AuthWrapper(
      title: 'Новый пароль',
      subtitle: 'Создайте новый пароль',
      children: [
        if (isTokenEmpty)
          const SizedBox() // Пустой виджет, если токен недействителен
        else
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Новый пароль
                AppTextField(
                  controller: passwordController,
                  label: 'Новый пароль',
                  hint: 'Введите новый пароль',
                  obscureText: !showPassword.value,
                  textInputAction: TextInputAction.next,
                  suffix: IconButton(
                    icon: Icon(
                      showPassword.value 
                        ? Icons.visibility_off 
                        : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => showPassword.value = !showPassword.value,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль';
                    }
                    if (value.length < 8) {
                      return 'Пароль должен содержать минимум 8 символов';
                    }
                    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$')
                        .hasMatch(value)) {
                      return 'Пароль должен содержать буквы и цифры';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                
                const Gap(16),
                
                // Подтверждение пароля
                AppTextField(
                  controller: confirmPasswordController,
                  label: 'Подтверждение пароля',
                  hint: 'Повторите новый пароль',
                  obscureText: !showConfirmPassword.value,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => resetPassword(),
                  suffix: IconButton(
                    icon: Icon(
                      showConfirmPassword.value 
                        ? Icons.visibility_off 
                        : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => 
                      showConfirmPassword.value = !showConfirmPassword.value,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Подтвердите пароль';
                    }
                    if (value != passwordController.text) {
                      return 'Пароли не совпадают';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                
                const Gap(32),
                
                // Кнопка сброса пароля
                AppButton(
                  text: 'Изменить пароль',
                  onPressed: resetPassword,
                  isLoading: isLoading.value,
                  width: double.infinity,
                ),
                
                const Gap(16),
                
                // Ссылка на вход
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Вспомнили пароль?'),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Войти'),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
} 