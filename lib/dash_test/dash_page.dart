import 'package:flutter/material.dart';
import 'package:flutter_tests/dash_test/dash_logic.dart';

abstract class DashAssets {
  static const dashBlueImage = "assets/dashes/dash_blue.png";
  static const dashGreenImage = "assets/dashes/dash_green.png";
}

class DashPage extends StatelessWidget {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("Dash app"),
        ),
      ),
    );
  }
}

class BirdView extends StatelessWidget {
  static const size = 60.0;
  final BirdType birdType;
  final VoidCallback? onTap;

  const BirdView({
    super.key,
    required this.birdType,
    required this.onTap,
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
                        child: BirdView(
                          key: ValueKey('$BirdStoreView${item.birdType}'),
                          birdType: item.birdType,
                          onTap: item.price <= state.balance ? () => store.buyBird(item) : null,
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
