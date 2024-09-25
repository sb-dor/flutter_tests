import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/dash_test/dash_logic.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final randomBird = Bird(BirdType.random);
  final bird = Bird(BirdType.constant);
  final mockedRandom = MockRandom();

  test(
    "if the bird is constant type then transaction should return constant value",
    () {
      // arrange
      final birdLogic = BirdLogic(Random());

      // act
      final result = birdLogic.invoke(bird);

      // assert (expect)
      expect(result, 100);
    },
  );

  test(
    'if the bird is random type then transaction should return random value',
    () {
      // arrange
      final birdLogic = BirdLogic(mockedRandom);
      when(() => mockedRandom.nextInt(1000)).thenReturn(35);

      // act
      final result = birdLogic.invoke(randomBird);

      // assert (expect)
      expect(result, 35);
    },
  );
}

class MockBirdLogic extends Mock implements BirdLogic {}

class MockRandom extends Mock implements Random {}
