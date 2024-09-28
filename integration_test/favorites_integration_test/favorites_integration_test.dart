import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/favorites_test/models/favorites.dart';
import 'package:flutter_tests/favorites_test/screens/favorites_home_page.dart';
import 'package:provider/provider.dart';

void main() {
  group(
    'Testing App',
    () {
      testWidgets(
        'Favorites operations test',
        (WidgetTester tester) async {
          await tester.pumpWidget(const TestApp());

          // you don't have to find widgets like this
          // instead set keys in widget and find them
          final iconKeys = [
            'icon_0',
            'icon_1',
            'icon_2',
          ];

          for (var icon in iconKeys) {
            await tester.tap(find.byKey(ValueKey(icon)));
            await tester.pumpAndSettle(const Duration(seconds: 1));

            expect(find.text('Added to favorites.'), findsOneWidget);
          }

          await tester.tap(find.text('Favorites'));
          await tester.pumpAndSettle();

          // you don't have to find widgets like this
          // instead set keys in widget and find them
          final removeIconKeys = [
            'remove_icon_0',
            'remove_icon_1',
            'remove_icon_2',
          ];

          for (final each in removeIconKeys) {
            await tester.tap(find.byKey(ValueKey(each)));
            await tester.pumpAndSettle(const Duration(seconds: 1));

            expect(find.text('Removed from favorites.'), findsOneWidget);
          }
        },
      );
    },
  );
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    // you have to put provider above material app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Favorites>(
          create: (_) => Favorites(),
        ),
      ],
      child: const MaterialApp(
        home: FavoritesHomePage(),
      ),
    );
  }
}
