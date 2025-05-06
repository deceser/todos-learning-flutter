// Модель задачи Todo
// Представляет собой основную сущность в приложении
class Todo {
  final String id; // Уникальный идентификатор задачи
  final String title; // Заголовок задачи
  final String? description; // Описание задачи (опционально)
  final bool isCompleted; // Статус выполнения задачи
  final DateTime createdAt; // Дата создания
  
  // Конструктор с именованными параметрами
  const Todo({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
  });
  
  // Метод копирования с изменением
  // Позволяет создать новый экземпляр с изменёнными полями
  Todo copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: this.createdAt,
    );
  }
} 