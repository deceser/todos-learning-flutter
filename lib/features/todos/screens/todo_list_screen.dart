import 'package:flutter/material.dart';
import '../../../core/models/todo.dart';
import '../../../core/repositories/todo_repository.dart';
import '../widgets/todo_item.dart';

// Экран со списком задач
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // Репозиторий для работы с задачами
  late final TodoRepository _todoRepository;
  
  // Список всех задач
  late List<Todo> _todos;
  
  // Контроллеры для текстовых полей
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Ключ формы для валидации
  final _formKey = GlobalKey<FormState>();
  
  // Текущая редактируемая задача
  Todo? _editingTodo;

  @override
  void initState() {
    super.initState();
    // Инициализируем репозиторий и загружаем задачи
    _todoRepository = FakeTodoRepository();
    _loadTodos();
  }

  @override
  void dispose() {
    // Освобождаем ресурсы
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  // Загрузка задач из репозитория
  void _loadTodos() {
    setState(() {
      _todos = _todoRepository.getTodos();
    });
  }
  
  // Переключение статуса задачи
  void _toggleTodoStatus(String id) {
    // Обновляем статус и перезагружаем список
    _todoRepository.toggleTodoStatus(id);
    _loadTodos();
  }
  
  // Удаление задачи
  void _deleteTodo(String id) {
    // Удаляем задачу и перезагружаем список
    _todoRepository.deleteTodo(id);
    _loadTodos();
    
    // Показываем снэкбар с уведомлением
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Задача удалена'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  // Показать диалог для добавления/редактирования задачи
  void _showAddEditTodoDialog([Todo? todo]) {
    // Если передана задача, то это редактирование
    _editingTodo = todo;
    
    // Заполняем поля значениями задачи или очищаем, если это новая задача
    if (todo != null) {
      _titleController.text = todo.title;
      _descriptionController.text = todo.description ?? '';
    } else {
      _titleController.clear();
      _descriptionController.clear();
    }
    
    // Показываем диалоговое окно
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_editingTodo == null 
            ? 'Добавить задачу' 
            : 'Редактировать задачу'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Поле для заголовка задачи
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите заголовок';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Поле для описания задачи
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          // Кнопка отмены
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          
          // Кнопка сохранения
          ElevatedButton(
            onPressed: _saveTodo,
            child: Text(_editingTodo == null ? 'Добавить' : 'Сохранить'),
          ),
        ],
      ),
    );
  }
  
  // Сохранение задачи
  void _saveTodo() {
    // Проверяем валидность формы
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text.isNotEmpty 
          ? _descriptionController.text 
          : null;
      
      if (_editingTodo == null) {
        // Добавляем новую задачу
        _todoRepository.addTodo(title, description);
      } else {
        // Обновляем существующую задачу
        final updatedTodo = _editingTodo!.copyWith(
          title: title,
          description: description,
        );
        _todoRepository.updateTodo(updatedTodo);
      }
      
      // Перезагружаем список и закрываем диалог
      _loadTodos();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список задач'),
        centerTitle: true,
      ),
      
      // Список задач
      body: _todos.isEmpty
          // Если список пуст, показываем сообщение
          ? const Center(
              child: Text(
                'Нет задач.\nНажмите + чтобы добавить.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          // Иначе отображаем список задач
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                
                // Используем ранее созданный виджет TodoItem
                return TodoItem(
                  todo: todo,
                  onToggleStatus: () => _toggleTodoStatus(todo.id),
                  onDelete: () => _deleteTodo(todo.id),
                  onEdit: () => _showAddEditTodoDialog(todo),
                );
              },
            ),
      
      // Кнопка добавления новой задачи
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditTodoDialog(),
        tooltip: 'Добавить задачу',
        child: const Icon(Icons.add),
      ),
    );
  }
} 