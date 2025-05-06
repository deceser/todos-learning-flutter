import 'package:uuid/uuid.dart';
import '../models/todo.dart';

// Абстрактный класс репозитория задач
// Определяет контракт для любых реализаций репозитория
abstract class TodoRepository {
  // Получить все задачи
  List<Todo> getTodos();
  
  // Добавить новую задачу
  Todo addTodo(String title, String? description);
  
  // Обновить существующую задачу
  Todo updateTodo(Todo todo);
  
  // Удалить задачу по идентификатору
  void deleteTodo(String id);
  
  // Переключить статус выполнения задачи
  Todo toggleTodoStatus(String id);
}

// Реализация репозитория с фейковыми данными
class FakeTodoRepository implements TodoRepository {
  // Список хранимых задач (имитация базы данных)
  final List<Todo> _todos = [];
  final Uuid _uuid = Uuid();
  
  // Конструктор, инициализирующий фейковые данные
  FakeTodoRepository() {
    // Добавляем несколько тестовых задач
    _initializeFakeTodos();
  }
  
  // Инициализация фейковых задач
  void _initializeFakeTodos() {
    final now = DateTime.now();
    
    _todos.addAll([
      Todo(
        id: _uuid.v4(),
        title: 'Изучить Flutter',
        description: 'Освоить основы создания UI и навигацию',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      Todo(
        id: _uuid.v4(),
        title: 'Создать первое приложение',
        description: 'Разработать простое приложение Todo',
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      Todo(
        id: _uuid.v4(),
        title: 'Опубликовать приложение',
        description: 'Подготовить и загрузить приложение в магазины',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ]);
  }
  
  @override
  List<Todo> getTodos() {
    // Возвращаем копию списка, чтобы избежать непреднамеренных изменений
    return List.from(_todos);
  }
  
  @override
  Todo addTodo(String title, String? description) {
    // Создаем новую задачу
    final newTodo = Todo(
      id: _uuid.v4(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    
    // Добавляем в список
    _todos.add(newTodo);
    
    return newTodo;
  }
  
  @override
  Todo updateTodo(Todo todo) {
    // Находим индекс задачи по id
    final index = _todos.indexWhere((t) => t.id == todo.id);
    
    if (index != -1) {
      // Обновляем задачу в списке
      _todos[index] = todo;
      return todo;
    }
    
    // Возвращаем оригинал, если обновление не произошло
    return todo;
  }
  
  @override
  void deleteTodo(String id) {
    // Удаляем задачу из списка
    _todos.removeWhere((todo) => todo.id == id);
  }
  
  @override
  Todo toggleTodoStatus(String id) {
    // Находим индекс задачи
    final index = _todos.indexWhere((todo) => todo.id == id);
    
    if (index != -1) {
      // Создаем новый экземпляр с измененным статусом
      final updatedTodo = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
      );
      
      // Обновляем задачу в списке
      _todos[index] = updatedTodo;
      return updatedTodo;
    }
    
    // Если задача не найдена, возвращаем null
    throw Exception('Задача с id $id не найдена');
  }
} 