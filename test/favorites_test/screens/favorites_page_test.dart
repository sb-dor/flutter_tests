import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/favorites_test/models/favorites.dart';
import 'package:flutter_tests/favorites_test/screens/favorites_page.dart';
import 'package:provider/provider.dart';

late Favorites favoritesList;

Widget createFavoritesPage() => ChangeNotifierProvider<Favorites>(
      create: (_) {
        favoritesList = Favorites();
        return favoritesList;
      },
      child: const MaterialApp(
        home: FavoritesPage(),
      ),
    );

void addItems() {
  for (var i = 0; i < 10; i += 2) {
    favoritesList.add(i);
  }
}

void main() {
  group(
    'Favorites Page Widget Tests',
    () {
      testWidgets(
        'Test if ListView shows up',
        (WidgetTester tester) async {
          //
          await tester.pumpWidget(createFavoritesPage());

          addItems();

          await tester.pumpAndSettle();

          expect(find.byType(ListView), findsOneWidget);
        },
      );

      //
      testWidgets(
        'Testing Remove Button',
        (WidgetTester tester) async {
          await tester.pumpWidget(createFavoritesPage());

          addItems();

          await tester.pumpAndSettle();

          var totalItems = tester.widgetList(find.byIcon(Icons.close)).length;

          await tester.tap(find.byIcon(Icons.close).first);

          await tester.pumpAndSettle();

          expect(tester.widgetList(find.byIcon(Icons.close)).length, lessThan(totalItems));

          expect(find.text('Removed from favorites.'), findsOneWidget);
        },
      );
    },
  );
}
