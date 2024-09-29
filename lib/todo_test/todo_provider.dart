import 'package:flutter/foundation.dart';
import 'package:flutter_tests/todo_test/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  final List<TodoModel> _todos = [];

  List<TodoModel> get todos => _todos;

  void addTodo(String name) async {
    final todo = TodoModel(name: name);
    _todos.add(todo);
    notifyListeners();
  }

  void removeTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }
}
