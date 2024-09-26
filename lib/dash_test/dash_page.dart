import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tests/dash_test/dash_logic.dart';

abstract class DashAssets {
  static const dashBlueImage = "assets/dashes/dash_blue.png";
  static const dashGreenImage = "assets/dashes/dash_green.png";
}

final random = Random();
final calc = BirdLogic(random);
final store = Store(AppState.initialState, calc);

class DashPage extends StatelessWidget {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: MainScreen(store: store),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final Store store;

  const MainScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            WalletView(store: store),
            Expanded(
              child: Center(
                child: StreamBuilder<AppState>(
                  initialData: store.appState,
                  stream: store.getChanges,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    final state = snapshot.requireData;
                    var uniqueKey = 0;
                    return SingleChildScrollView(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        children: state.birds
                            .map(
                              (bird) => _BirdView(
                                key: ValueKey('$MainScreen${bird.birdType}${uniqueKey++}'),
                                birdType: bird.birdType,
                                onTap: () => store.earn(bird),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
            BirdStoreView(store: store),
          ],
        ),
      ),
    );
  }
}

class _BirdView extends StatelessWidget {
  static const size = 60.0;
  final BirdType birdType;
  final VoidCallback? onTap;

  const _BirdView({
    super.key,
    required this.birdType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: InkResponse(
        onTap: onTap,
        child: Image.asset(_asset(birdType)),
      ),
    );
  }

  String _asset(BirdType type) {
    switch (type) {
      case BirdType.constant:
        return DashAssets.dashBlueImage;
      case BirdType.random:
        return DashAssets.dashGreenImage;
    }
  }
}

class BirdStoreView extends StatelessWidget {
  final Store store;

  const BirdStoreView({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<AppState>(
            initialData: store.appState,
            stream: store.getChanges,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              final state = snapshot.requireData;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: state.birdsItem
                    .map(
                      (item) => Opacity(
                        opacity: item.price <= state.balance ? 1.0 : 0.2,
                        child: _BirdView(
                          key: ValueKey('$BirdStoreView${item.birdType}'),
                          birdType: item.birdType,
                          onTap: () => store.buyBird(item),
                        ),
                      ),
                    )
                    .toList(),
              );
            }),
      ),
    );
  }
}

class WalletView extends StatelessWidget {
  final Store store;

  const WalletView({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Баланс',
                style: TextStyle(fontSize: 18),
              ),
              StreamBuilder<AppState>(
                initialData: store.appState,
                stream: store.getChanges,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  final state = snapshot.requireData;
                  return Text(
                    '\$${state.balance}',
                    key: ValueKey('${WalletView}balance'),
                    style: TextStyle(fontSize: 28),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
