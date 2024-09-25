import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/dash_test/dash_logic.dart';
import 'package:flutter_tests/dash_test/dash_page.dart';

import 'dashed_logic_test.dart';

void main() {
  late Random random;
  late BirdLogic birdLogic;
  late Store store;

  // initialization
  setUp(() {
    random = MockRandom(); // from dashed_logic_test.dart
    birdLogic = BirdLogic(random);
    store = Store(AppState.initialState, birdLogic);
  });

  // invokes after test (similar to dispose() method)
  tearDown(() {
    // when you want to clear something
    // etc.
  });

  testWidgets(
    "show items after initialization",
    (tester) async {
      // add widget
      await tester.pumpWidget(
        TestWidget(
          widget: MainScreen(
            store: store,
          ), // widget from dash_page.dart
        ),
      );

      final constantItemFinder = find.byKey(
        ValueKey('$BirdStoreView${BirdType.constant}'),
      );

      final randomItemFinder = find.byKey(
        ValueKey('$BirdStoreView${BirdType.random}'),
      );

      // rendering ui
      await tester.pump(); // runs widget

      // rendering ui if it has animations
      // await test.pumpAndSettle(); // run if you have animation

      expect(constantItemFinder, findsOneWidget);

      expect(randomItemFinder, findsOneWidget);
    },
  );

  testWidgets(
    'clicking on constant item and check that the bird was added',
    (tester) async {
      // add widget for testing
      await tester.pumpWidget(
        TestWidget(
          widget: MainScreen(store: store),
        ),
      );

      // the widget that user should tap on
      final constantBirdItem = find.byKey(
        ValueKey('$BirdStoreView${BirdType.constant}'),
      );

      // the list of items that exist in List
      var lengthOfAddedConstantBirds = store.appState.birds
          .where(
            (bird) => bird.birdType == BirdType.constant,
          )
          .length;

      debugPrint("length of list: ${store.appState.birds.length}");

      lengthOfAddedConstantBirds += 1;

      await tester.tap(constantBirdItem); // tap on widget
      await tester.pump(); // render again

      debugPrint("length of list: ${store.appState.birds.length}");

      // the list of items that was rendered in UI
      final constantBirds = find.byWidgetPredicate(
        (widget) {
          return widget.key != null &&
              widget.key is ValueKey<String> &&
              (widget.key as ValueKey<String>).value.contains(
                    '$MainScreen${BirdType.constant}',
                  );
        },
      );

      //
      expect(constantBirds, findsNWidgets(lengthOfAddedConstantBirds));
    },
  );
}

class TestWidget extends StatelessWidget {
  final Widget widget;

  const TestWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: widget,
    );
  }
}
