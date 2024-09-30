import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/todo_test/todo_model.dart';
import 'package:flutter_tests/todo_test/todo_page.dart';
import 'package:flutter_tests/todo_test/todo_provider.dart';
import 'package:provider/provider.dart';

void main() {
  const String textControllerKey = 'text_controller';
  const String addIconButtonKey = 'add_icon_button';
  const String listViewKey = 'todo_app_listview';
  const String itemTextKey = 'text_item_';
  const String itemDeleteButtonKey = 'delete_button_';
  final TodoModel todoModel = TodoModel(name: "Have to do homework");
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

          await tester.enterText(textField, todoModel.name!);

          await tester.pumpAndSettle();

          expect(find.text(todoModel.name!), findsOneWidget);

          await tester.tap(addButton);

          await tester.pumpAndSettle();

          final findListView = find.byKey(const ValueKey(listViewKey));

          expect(findListView, findsOneWidget);

          expect(todoProvider.todos.isNotEmpty, true);

          for (final each in todoProvider.todos) {
            final findText = find.byKey(ValueKey("$itemTextKey${each.id}"));
            expect(findText, findsOneWidget);

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
