import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/todo_test/todo_model.dart';
import 'package:flutter_tests/todo_test/todo_page.dart';
import 'package:flutter_tests/todo_test/todo_provider.dart';
import 'package:provider/provider.dart';

import '../../integration_test/listview_scroll_test/listview_scroll_test.dart';

void main() {
  const String textControllerKey = 'text_controller';
  const String addIconButtonKey = 'add_icon_button';
  const String listViewKey = 'todo_app_listview';
  const String itemTextKey = 'text_item_';
  const String itemDeleteButtonKey = 'delete_button_';
  final List<TodoModel> todos = <TodoModel>[
    TodoModel(name: "Have to do homework"),
    TodoModel(name: "Have to visit grandparents"),
    TodoModel(name: "Have to do chores"),
  ];
  late TodoProvider todoProvider;
  late Widget testApp;

  setUpAll(
    () {
      todoProvider = TodoProvider();
      testApp = _TestApp(todoProvider: todoProvider);
    },
  );

  group(
    'todo page widget tests',
    () {
      testWidgets(
        'add widget test',
        (WidgetTester tester) async {
          await tester.pumpWidget(testApp);

          final textField = find.byKey(const ValueKey(textControllerKey));

          expect(textField, findsOneWidget);

          final addButton = find.byKey(const ValueKey(addIconButtonKey));

          expect(addButton, findsOneWidget);

          for (final each in todos) {
            await tester.enterText(textField, each.name!);

            await tester.pumpAndSettle();

            expect(find.text(each.name!), findsOneWidget);

            await tester.tap(addButton);

            await tester.pumpAndSettle();
          }

          final findListView = find.byKey(const ValueKey(listViewKey));

          expect(findListView, findsOneWidget);

          expect(todoProvider.todos.isNotEmpty, true);

          for (final each in todoProvider.todos) {
            final findText = find.byKey(ValueKey("$itemTextKey${each.id}"));
            expect(findText, findsOneWidget);
          }

          expect(todoProvider.todos.length, todos.length);
        },
      );

      //
      testWidgets(
        'remove item widget test',
        (WidgetTester tester) async {
          await tester.pumpWidget(testApp);

          todoProvider.initTodos(todos);

          await tester.pumpAndSettle();

          final cloneTodos = [...todoProvider.todos];

          for (final each in cloneTodos) {
            final findItemButton = find.byKey(ValueKey<String>("$itemDeleteButtonKey${each.id}"));

            expect(findItemButton, findsOneWidget);

            await tester.tap(findItemButton);

            await tester.pumpAndSettle();

            expect(findItemButton, findsNothing);
          }
        },
      );
    },
  );
}

class _TestApp extends StatelessWidget {
  final TodoProvider todoProvider;

  const _TestApp({
    super.key,
    required this.todoProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoProvider>(
      create: (_) => todoProvider,
      child: const MaterialApp(
        home: TodoPage(),
      ),
    );
  }
}
