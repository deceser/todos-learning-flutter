import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:learning_app_flutter/application/auth/resend_verification_email_usecase.dart';
import 'package:learning_app_flutter/core/di/providers.dart';
import 'package:learning_app_flutter/presentation/widgets/app_button.dart';
import 'package:learning_app_flutter/presentation/widgets/auth_wrapper.dart';

class EmailVerificationScreen extends HookConsumerWidget {
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Состояние таймера для повторной отправки
    final resendTimerSeconds = useState(60);
    final isResendDisabled = resendTimerSeconds.value > 0;
    final isLoading = useState(false);
    
    // Создаем таймер для обратного отсчета
    useEffect(() {
      Timer? timer;
      
      if (resendTimerSeconds.value > 0) {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (resendTimerSeconds.value <= 0) {
            timer.cancel();
          } else {
            resendTimerSeconds.value--;
          }
        });
      }
      
      return () => timer?.cancel();
    }, [resendTimerSeconds.value]);
    
    // Функция повторной отправки письма
    Future<void> resendVerificationEmail() async {
      if (isLoading.value || isResendDisabled) return;
      
      isLoading.value = true;
      
      try {
        final resendEmailUseCase = ref.read(resendVerificationEmailUseCaseProvider);
        final result = await resendEmailUseCase.execute(email);
        
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Письмо успешно отправлено'),
                backgroundColor: Colors.green,
              ),
            );
            resendTimerSeconds.value = 60; // Сбрасываем таймер
          },
        );
      } finally {
        isLoading.value = false;
      }
    }
    
    return AuthWrapper(
      title: 'Подтверждение Email',
      subtitle: 'Мы отправили письмо с инструкциями',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(8),
            
            // Описание процесса верификации
            Text(
              'Для продолжения необходимо подтвердить ваш email. '
              'Мы отправили письмо с ссылкой для подтверждения на адрес:',
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
                email,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const Gap(16),
            
            // Инструкция
            Text(
              'Перейдите по ссылке в письме для завершения регистрации. '
              'Если письмо не пришло, проверьте папку "Спам" или запросите повторную отправку.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            
            const Gap(32),
            
            // Кнопка повторной отправки
            AppButton(
              text: isResendDisabled
                  ? 'Отправить повторно (${resendTimerSeconds.value})'
                  : 'Отправить повторно',
              onPressed: resendVerificationEmail,
              isLoading: isLoading.value,
              isOutlined: true,
              width: double.infinity,
              color: isResendDisabled ? Colors.grey : null,
            ),
          ],
        ),
      ],
    );
  }
} 