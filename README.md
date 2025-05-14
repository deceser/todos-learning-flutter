# Архитектура аутентификации для Flutter-приложения

## 📋 Обзор

Проект основан на Clean Architecture и разделен на следующие слои:

- **Presentation (UI)** – экраны, виджеты, формы и навигация
- **Application (Use Cases)** – бизнес-логика приложения
- **Domain** – сущности и абстракции репозиториев
- **Infrastructure (Data)** – API-слой, модели данных, реализации репозиториев
- **Core/Common** – утилиты, конфигурации, shared-компоненты

## 🗂️ Структура проекта

```
lib/
├── core/                          # Общие компоненты
│   ├── network/                   # Сетевые утилиты
│   │   ├── dio_client.dart        # HTTP-клиент
│   │   └── token_interceptor.dart # Авторизационный интерцептор
│   ├── storage/                   # Хранение данных
│   └── utils/                     # Вспомогательные функции
├── data/                          # Слой данных
│   └── auth/
│       ├── models/                # Модели DTO
│       ├── auth_api_service.dart  # API-сервис
│       └── auth_repository_impl.dart # Реализация репозитория
├── domain/                        # Доменный слой
│   ├── entities/                  # Бизнес-сущности
│   │   └── user.dart
│   └── repositories/              # Интерфейсы репозиториев
│       └── auth_repository.dart
├── application/                   # Слой приложения
│   └── auth/                      # Use Cases
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       └── ...
├── presentation/                  # UI слой
│   ├── router/                    # Навигация
│   ├── screens/                   # Экраны
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── ...
│   │   └── home_screen.dart
│   ├── widgets/                   # Переиспользуемые виджеты
│   └── state/                     # Управление состоянием
│       └── auth/
└── main.dart                      # Точка входа
```

## 🔄 Процесс аутентификации

1. **Регистрация**: создание аккаунта → подтверждение email
2. **Вход**: получение токенов → сохранение в Secure Storage
3. **Авторизация**: автоматическое добавление токена к запросам
4. **Refresh Token**: автоматическое обновление токена при истечении
5. **Восстановление пароля**: запрос → получение email → сброс пароля

## 🛠️ Технологии

- **HTTP-клиент**: Dio с интерцепторами
- **Управление состоянием**: Riverpod
- **Роутинг**: GoRouter
- **Хранение токенов**: Flutter Secure Storage
- **Модели**: Freezed, JSON Serializable

## 📱 Экраны аутентификации

- Вход (Login)
- Регистрация (Register)
- Подтверждение Email (Email Verification)
- Забыли пароль (Forgot Password)
- Сброс пароля (Reset Password)

## 🔐 API-эндпоинты

- **POST /api/auth/register** – регистрация
- **POST /api/auth/login** – вход
- **GET /api/auth/verify-email** – подтверждение email
- **POST /api/auth/resend-verification** – повторная отправка письма
- **POST /api/auth/forgot-password** – запрос на сброс пароля
- **POST /api/auth/reset-password** – сброс пароля
- **POST /api/auth/refresh** – обновление токена
- **POST /api/auth/logout** – выход
