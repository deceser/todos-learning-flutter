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

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controllers для текстовых полей
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    
    // Состояния показа/скрытия паролей
    final showPassword = useState(false);
    final showConfirmPassword = useState(false);
    
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
    
    // Функция регистрации
    void register() {
      if (formKey.currentState?.validate() ?? false) {
        final username = usernameController.text.trim();
        final email = emailController.text.trim();
        final password = passwordController.text;
        
        ref.read(authNotifierProvider.notifier).register(
          username: username,
          email: email,
          password: password,
        );
      }
    }
    
    return AuthWrapper(
      title: 'Регистрация',
      subtitle: 'Создайте новый аккаунт',
      children: [
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Имя пользователя
              AppTextField(
                controller: usernameController,
                label: 'Имя пользователя',
                hint: 'Введите имя пользователя',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите имя пользователя';
                  }
                  if (value.length < 3) {
                    return 'Имя должно содержать минимум 3 символа';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              
              const Gap(16),
              
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
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Введите корректный email';
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
                hint: 'Придумайте пароль',
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
                hint: 'Повторите пароль',
                obscureText: !showConfirmPassword.value,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => register(),
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
              
              // Кнопка регистрации
              AppButton(
                text: 'Зарегистрироваться',
                onPressed: register,
                isLoading: isLoading,
                width: double.infinity,
              ),
              
              const Gap(16),
              
              // Ссылка на вход
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Уже есть аккаунт?'),
                  TextButton(
                    onPressed: () => context.push('/login'),
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