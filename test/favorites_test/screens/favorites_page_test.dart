import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/favorites_test/models/favorites.dart';
import 'package:flutter_tests/favorites_test/screens/favorites_page.dart';
import 'package:provider/provider.dart';

Widget createFavoritesPage() => ChangeNotifierProvider<Favorites>(
      create: (_) => Favorites(),
      child: const MaterialApp(
        home: FavoritesPage(),
      ),
    );

void main() {
  late Favorites favoritesList;

  setUpAll(
    () {
      favoritesList = Favorites();
    },
  );

  void addItems() {
    for (var i = 0; i < 10; i += 2) {
      favoritesList.add(i);
    }
  }

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
    },
  );
}
