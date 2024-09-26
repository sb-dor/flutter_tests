import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  late FlutterDriver driver;
  final constantItemFinder = find.byValueKey('BirdStoreViewBirdType.constant');
  final firstBirdFinder = find.byValueKey('MainPageBirdType.constant0');
  final balanceFinder = find.byValueKey('WalletViewbalance');

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    await driver.close();
  });

  test('when balance less then 25 cannot tap constant bird', () async {
    var actualBalance = await driver.getText(balanceFinder);
    expect(actualBalance, '\$0');

    for (var i = 0; i < 24; i++) {
      await driver.tap(firstBirdFinder);
    }

    await driver.tap(constantItemFinder);

    actualBalance = await driver.getText(balanceFinder);
    expect(actualBalance, '\$24');

    await driver.tap(firstBirdFinder);

    await driver.tap(constantItemFinder);
    actualBalance = await driver.getText(balanceFinder);
    expect(actualBalance, '\$0');

    final secondBirdFinder = find.byValueKey('MainPageBirdType.constant1');

    await driver.waitFor(secondBirdFinder, timeout: const Duration(milliseconds: 200));

    await driver.tap(secondBirdFinder);
    actualBalance = await driver.getText(balanceFinder);
    expect(actualBalance, '\$1');
  });
}
