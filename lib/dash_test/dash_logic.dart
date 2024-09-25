import 'dart:math';

enum BirdType { constant, random }

class Bird {
  final BirdType birdType;

  Bird(this.birdType);
}

class BirdLogic {
  final Random random;

  BirdLogic(this.random);

  int invoke(Bird bird) {
    switch (bird.birdType) {
      case BirdType.constant:
        return 100;
      case BirdType.random:
        return random.nextInt(1000);
    }
  }
}
