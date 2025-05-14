import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app_flutter/application/auth/forgot_password_usecase.dart';
import 'package:learning_app_flutter/core/di/providers.dart';
import 'package:learning_app_flutter/presentation/widgets/app_button.dart';
import 'package:learning_app_flutter/presentation/widgets/app_text_field.dart';
import 'package:learning_app_flutter/presentation/widgets/auth_wrapper.dart';

class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controllers для текстовых полей
    final emailController = useTextEditingController();
    
    // Состояние формы для валидации
    final formKey = useMemoized(() => GlobalKey<FormState>());
    
    // Состояния загрузки и успешной отправки
    final isLoading = useState(false);
    final isEmailSent = useState(false);
    
    // Функция отправки запроса на восстановление пароля
    Future<void> sendResetPasswordEmail() async {
      if (formKey.currentState?.validate() ?? false) {
        isLoading.value = true;
        
        try {
          final email = emailController.text.trim();
          final forgotPasswordUseCase = ref.read(forgotPasswordUseCaseProvider);
          final result = await forgotPasswordUseCase.execute(email);
          
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
              isEmailSent.value = true;
            },
          );
        } finally {
          isLoading.value = false;
        }
      }
    }
    
    if (isEmailSent.value) {
      // Показываем экран успешной отправки
      return AuthWrapper(
        title: 'Письмо отправлено',
        subtitle: 'Проверьте вашу почту',
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(8),
              
              // Описание процесса восстановления
              Text(
                'Мы отправили инструкции по восстановлению пароля на адрес:',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              
              const Gap(16),
              
              // Email пользователя
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  emailController.text.trim(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const Gap(16),
              
              // Инструкция
              Text(
                'Перейдите по ссылке в письме для сброса пароля. '
                'Если письмо не пришло, проверьте папку "Спам" или попробуйте снова.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              
              const Gap(32),
              
              // Кнопка возврата на экран входа
              AppButton(
                text: 'Вернуться на страницу входа',
                onPressed: () => context.go('/login'),
                width: double.infinity,
              ),
              
              const Gap(16),
              
              // Кнопка повторной отправки
              AppButton(
                text: 'Отправить еще раз',
                onPressed: () => isEmailSent.value = false,
                isOutlined: true,
                width: double.infinity,
              ),
            ],
          ),
        ],
      );
    }
    
    return AuthWrapper(
      title: 'Забыли пароль?',
      subtitle: 'Введите ваш email для восстановления',
      children: [
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email поле
              AppTextField(
                controller: emailController,
                label: 'Email',
                hint: 'Введите ваш email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => sendResetPasswordEmail(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите email';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Введите корректный email';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              
              const Gap(32),
              
              // Кнопка отправки
              AppButton(
                text: 'Отправить инструкции',
                onPressed: sendResetPasswordEmail,
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