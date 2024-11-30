import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/favorites_test/models/favorites.dart';
import 'package:flutter_tests/favorites_test/screens/favorites_home_page.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

void main() {

  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  late Favorites provider;

  setUpAll(() {
    provider = Favorites();
  },);

  group(
    'Testing App',
        () {


      testWidgets(
        'Favorites operations test',
            (WidgetTester tester) async {
          await tester.pumpWidget(TestApp(provider: provider));

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

      //
      testWidgets(
        'Favorites page screen scroll test',
            (WidgetTester tester) async {
          final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
          binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

          await tester.pumpWidget(TestApp(provider: provider));

          final listView = find.byType(ListView);

          binding.traceAction(() async {
            await tester.fling(
              listView,
              const Offset(0, -500),
              10000,
            );

            await tester.pumpAndSettle();

            await tester.fling(
              listView,
              const Offset(0, 500),
              10000,
            );

            await tester.pumpAndSettle();
          }, reportKey: 'scrolling_summary');
        },
      );

      //
      testWidgets(
        "removing by dragging test",
            (WidgetTester tester) async {
          await tester.pumpWidget(TestApp(provider: provider));

          final iconKeys = [
            'icon_0',
            'icon_1',
            'icon_2',
          ];

          for (final each in iconKeys) {
            final findIcon = find.byKey(ValueKey(each));
            await tester.tap(findIcon);
            await tester.pumpAndSettle(const Duration(seconds: 1));
          }

          final findFavoritesTextButton = find
              .text('Favorites')
              .first;
          await tester.tap(findFavoritesTextButton);
          await tester.pumpAndSettle();

          final removeIconKeys = [
            'dismissible_0',
            'dismissible_1',
            'dismissible_2',
          ];

          for (final each in removeIconKeys) {
            final findDismissible = find
                .byKey(ValueKey(each))
                .first;
            await tester.drag(findDismissible, const Offset(-500, 0));
            await tester.pumpAndSettle(const Duration(seconds: 1));

            final findRemoveText = find.text('Removed from favorites.');
            expect(findRemoveText, findsOneWidget);
          }

          expect(provider.items.isEmpty, true);
        },
      );
    },
  );
}

class TestApp extends StatelessWidget {
  final Favorites provider;

  const TestApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    // you have to put provider above material app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Favorites>(
          create: (_) => provider,
        ),
      ],
      child: const MaterialApp(
        home: FavoritesHomePage(),
      ),
    );
  }
}
