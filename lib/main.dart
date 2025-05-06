import 'package:flutter/material.dart';
import 'features/todos/screens/todo_list_screen.dart';

void main() {
  runApp(const TodoApp());
}

// Основной виджет приложения
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Название приложения
      title: 'Todo App',
      
      // Настройка темы приложения
      theme: ThemeData(
        // Основной цвет приложения
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        
        // Настройка AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade500,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        
        // Настройка карточек
        cardTheme: const CardTheme(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        ),
        
        // Настройка кнопок
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        
        // Настройка плавающей кнопки
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade500,
          foregroundColor: Colors.white,
        ),
      ),
      
      // Отключаем баннер debug
      debugShowCheckedModeBanner: false,
      
      // Устанавливаем домашний экран - список задач
      home: const TodoListScreen(),
    );
  }
}
