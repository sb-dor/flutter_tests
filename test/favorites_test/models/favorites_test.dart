import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/favorites_test/models/favorites.dart';

void main() {
  late final Favorites favorites;

  setUpAll(
    () {
      favorites = Favorites();
    },
  );

  group(
    'Testing App Provider',
    () {
      //
      test(
        'A new item should be added',
        () {
          var number = 35;
          favorites.add(number);
          expect(favorites.items.contains(number), true);
        },
      );

      //
      test(
        'An item should be removed',
        () {
          var number = 30;
          favorites.add(number);
          expect(favorites.items.contains(number), true);
          favorites.remove(number);
          expect(favorites.items.contains(number), false);
        },
      );
    },

    //
  );
}
