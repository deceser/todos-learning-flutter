import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app_flutter/presentation/state/auth/auth_notifier.dart';
import 'package:learning_app_flutter/presentation/state/auth/auth_state.dart';
import 'package:learning_app_flutter/presentation/widgets/app_button.dart';
import 'package:learning_app_flutter/presentation/widgets/app_text_field.dart';
import 'package:learning_app_flutter/presentation/widgets/auth_wrapper.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controllers для текстовых полей
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    
    // Состояние показа/скрытия пароля
    final showPassword = useState(false);
    
    // Состояние формы для валидации
    final formKey = useMemoized(() => GlobalKey<FormState>());
    
    // Получение состояния аутентификации
    final authState = ref.watch(authNotifierProvider);
    
    // Проверка состояния загрузки
    final isLoading = authState is AuthState ? authState.maybeMap(
      loading: (_) => true,
      orElse: () => false,
    ) : false;
    
    // Обработчик состояния ошибки
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authState.maybeMap(
          error: (errorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorState.message),
                backgroundColor: Colors.red,
              ),
            );
          },
          orElse: () {},
        );
      });
      return null;
    }, [authState]);
    
    // Функция авторизации
    void login() {
      if (formKey.currentState?.validate() ?? false) {
        final email = emailController.text.trim();
        final password = passwordController.text;
        
        ref.read(authNotifierProvider.notifier).login(
          email: email,
          password: password,
        );
      }
    }
    
    return AuthWrapper(
      title: 'Вход в аккаунт',
      subtitle: 'Введите данные для входа в систему',
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
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите email';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              
              const Gap(16),
              
              // Пароль поле
              AppTextField(
                controller: passwordController,
                label: 'Пароль',
                hint: 'Введите ваш пароль',
                obscureText: !showPassword.value,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => login(),
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
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              
              // Забыли пароль
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/forgot-password'),
                  child: const Text('Забыли пароль?'),
                ),
              ),
              
              const Gap(24),
              
              // Кнопка входа
              AppButton(
                text: 'Войти',
                onPressed: login,
                isLoading: isLoading,
                width: double.infinity,
              ),
              
              const Gap(16),
              
              // Ссылка на регистрацию
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Еще нет аккаунта?'),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: const Text('Зарегистрироваться'),
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