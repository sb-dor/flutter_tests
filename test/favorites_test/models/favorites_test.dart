import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/favorites_test/models/favorites.dart';

void main() {
  late final Favorites favorites;

  setUp(
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
    },

    //
  );
}
