import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/favorites_test/models/favorites.dart';
import 'package:flutter_tests/favorites_test/screens/favorites_home_page.dart';
import 'package:provider/provider.dart';

class CreateHomePage extends StatelessWidget {
  const CreateHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Favorites>(
      create: (_) => Favorites(),
      child: const MaterialApp(
        home: FavoritesHomePage(),
      ),
    );
  }
}


void main() {
  //
  group(
    'favorites home page test',
    () {
      testWidgets('Testing if ListView shows up', (tester) async {
        // Render the HomePage widget
        await tester.pumpWidget(const CreateHomePage());
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets(
        'testing scrolling',
        // Widget tests are always asynchronous
        (WidgetTester tester) async {
          // Render the HomePage widget
          await tester.pumpWidget(const CreateHomePage());

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

      //
      // This test verifies that tapping the IconButton changes from Icons.favorite_border
      // (an open heart) to Icons.favorite (a filled-in heart) and then back to Icons.favorite_border
      // when tapped again.
      testWidgets('Testing IconButtons', (tester) async {
        //
        await tester.pumpWidget(const CreateHomePage());

        // first check that there is no any widget with Icons.favorite
        expect(find.byIcon(Icons.favorite), findsNothing);

        // tap on the first found item which item's icon is favorite_border (hasn't added to the list yet)
        await tester.tap(find.byIcon(Icons.favorite_border).first);

        // re render the widget
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // check that item was added
        expect(find.text('Added to favorites.'), findsOneWidget);

        // check that there are icons that was changed
        expect(find.byIcon(Icons.favorite), findsWidgets);

        // tap the changed widget that it's icon was changed into favorite
        await tester.tap(find.byIcon(Icons.favorite).first);

        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Removed from favorites.'), findsOneWidget);

        // check that there is no any widget with added favorite anymore
        expect(find.byIcon(Icons.favorite), findsNothing);
      });
    },
  );
}
