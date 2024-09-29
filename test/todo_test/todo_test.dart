import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/todo_test/todo_model.dart';
import 'package:flutter_tests/todo_test/todo_page.dart';
import 'package:flutter_tests/todo_test/todo_provider.dart';
import 'package:provider/provider.dart';

void main() {
  late TodoProvider provider;

  setUpAll(() {
    provider = TodoProvider();
  });

  group(
    'test todo provider',
    () {
      test(
        'test whether item added inside list',
        () {
          const String text = "Have to do homework";

          expect(provider.todos, isEmpty);

          provider.addTodo(text);

          final findTodo = provider.todos.any((todo) => todo.name == text);

          expect(provider.todos.isNotEmpty, true);

          expect(findTodo, true);
        },
      );
    },
  );
}
