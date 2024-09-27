import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/favorites_test/models/favorites.dart';
import 'package:flutter_tests/favorites_test/screens/favorites_home_page.dart';
import 'package:provider/provider.dart';

Widget createHomePage() => ChangeNotifierProvider<Favorites>(
      create: (_) => Favorites(),
      child: const MaterialApp(
        home: FavoritesHomePage(),
      ),
    );

void main() {
  //
  group(
    'favorites home page test',
    () {
      testWidgets(
        'testing scrolling',
        // Widget tests are always asynchronous
        (WidgetTester tester) async {
          // Render the HomePage widget
          await tester.pumpWidget(createHomePage());

          // Verify that 'Item 0' is initially visible on the screen
          expect(find.text('Item 0'), findsOneWidget);

          // Simulate a fling (scrolling gesture) on the ListView widget.
          // The gesture starts at the center of the ListView and moves upwards
          // by 200 pixels with a speed of 300.
          await tester.fling(
            find.byType(ListView),
            const Offset(0, -200), // Negative value for upward scrolling
            300, // Speed of the fling
          );

          // Wait for the scrolling animation to finish and for the widget tree to settle
          await tester.pumpAndSettle();

          // Verify that 'Item 0' is no longer visible after the scroll
          expect(find.text('Item 0'), findsNothing);
        },
      );
    },
  );
}
