import 'dart:async';
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

class BirdItem {
  final BirdType birdType;
  final int price;

  BirdItem(this.birdType, this.price);
}

class AppState {
  static final initialState = AppState(
    balance: 0,
    birds: [Bird(BirdType.constant)],
    birdsItem: [
      BirdItem(BirdType.constant, 25),
      BirdItem(BirdType.random, 100),
    ],
  );

  final int balance;
  final List<Bird> birds;
  final List<BirdItem> birdsItem;

  AppState({
    this.balance = 0,
    this.birds = const [],
    this.birdsItem = const [],
  });

  AppState copyWith({
    int? balance,
    List<Bird>? birds,
    List<BirdItem>? birdsItem,
  }) {
    return AppState(
      balance: balance ?? this.balance,
      birds: birds ?? this.birds,
      birdsItem: birdsItem ?? this.birdsItem,
    );
  }
}

class Store {
  final AppState appState;
  final _controller = StreamController<AppState>.broadcast();
  final BirdLogic birdLogic;

  Stream<AppState> get getChanges => _controller.stream;

  Store(this.appState, this.birdLogic);

  void buyBird(BirdItem bird) {
    _controller.add(appState);
  }

  void earn(Bird bird) {
    _controller.add(appState);
  }
}
