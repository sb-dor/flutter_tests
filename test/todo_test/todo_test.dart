import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/todo_test/todo_model.dart';
import 'package:flutter_tests/todo_test/todo_page.dart';
import 'package:flutter_tests/todo_test/todo_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';


void main() {
  late TodoProvider provider;
  final TodoModel todoModel = TodoModel(name: "Have to do homework");

  setUpAll(() {
    provider = TodoProvider();
  });

  group(
    'test todo provider',
    () {
      test(
        'test whether item added inside list',
        () {
          expect(provider.todos, isEmpty);

          provider.addTodo(todoModel.name!);

          final findTodo = provider.todos.any((todo) => todo.name == todoModel.name);

          expect(provider.todos.isNotEmpty, true);

          expect(findTodo, true);
        },
      );

      //
      test(
        'test item should be removed from list',
        () {
          provider.initTodos([todoModel]);

          expect(provider.todos.isNotEmpty, true);

          provider.removeTodo(todoModel);

          expect(provider.todos.isEmpty, true);
        },
      );
    },
  );
}
