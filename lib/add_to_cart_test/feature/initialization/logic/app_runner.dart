import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/view/pages/home_page.dart';
import 'package:flutter_tests/add_to_cart_test/feature/initialization/logic/composition_root.dart';
import 'package:flutter_tests/add_to_cart_test/feature/initialization/widget/bloc_multi_provider_helper.dart';
import 'package:flutter_tests/add_to_cart_test/feature/initialization/widget/material_context.dart';

final class AppRunner {
  Future<void> initApp() async {
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        final result = await CompositionRoot().compose();
        runApp(
          // helper that provides BlocProviders
          BlocMultiProvideHelper(
            compositionResult: result,
            child: const MaterialContext(
              child: HomePage(),
            ),
          ),
        );
      },
      (error, sTrace) {
        debugPrint("error is $error | trace: $sTrace");
        // debug error
      },
    );
  }
}
