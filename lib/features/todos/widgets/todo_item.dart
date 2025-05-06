import 'package:flutter/material.dart';
import '../../../core/models/todo.dart';

// Виджет для отображения отдельной задачи в списке
class TodoItem extends StatelessWidget {
  // Модель задачи для отображения
  final Todo todo;
  
  // Коллбэки для обработки событий
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  
  // Конструктор
  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggleStatus,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Используем ListTile для простого и красивого отображения элемента списка
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        // Чекбокс для переключения статуса задачи
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggleStatus(),
        ),
        
        // Заголовок задачи с зачеркиванием, если задача выполнена
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: todo.isCompleted 
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
            color: todo.isCompleted 
                ? Colors.grey 
                : Colors.black,
          ),
        ),
        
        // Описание задачи, если оно есть
        subtitle: todo.description != null && todo.description!.isNotEmpty
            ? Text(
                todo.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: todo.isCompleted 
                      ? Colors.grey.shade500 
                      : Colors.grey.shade700,
                ),
              )
            : null,
        
        // Кнопки действий
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Кнопка редактирования
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
              tooltip: 'Редактировать',
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
            
            // Кнопка удаления
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: onDelete,
              tooltip: 'Удалить',
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
          ],
        ),
      ),
    );
  }
} 