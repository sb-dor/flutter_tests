import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/listview_scroll_test/listview_scroll_test.dart';

void main() {
  testWidgets(
    'test listview scroll until specific widget is found',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp());

      final findListView = find.byKey(const ValueKey("scrollable_listview")).first;

      expect(findListView, findsOneWidget);

      final specificWidget = find.byKey(const ValueKey("generated_text_500"));

      await tester.dragUntilVisible(
        specificWidget,
        findListView,
        const Offset(0, -500),
      );

      expect(specificWidget, findsOneWidget);
    },
  );
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListviewScrollTest(),
    );
  }
}
