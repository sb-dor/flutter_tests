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

        // https://lazebny.io/mastering-error-handling/#handling-flutter-errors
        // await Firebase.initializeApp();
        // Triggered by widget-related issues, such as a RenderFlex overflow.
        FlutterError.onError = (error) {
          debugPrint("flutter error is $error");
        };
        // you can use firebase crashlytics
        // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

        // Activates on platform exceptions, like MethodChannel failures.
        WidgetsBinding.instance.platformDispatcher.onError = (error, stackTrace) {
          debugPrint("flutter platformDispatcher error is: $error | stackTrace: $stackTrace");
          return true;
        };

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
        debugPrint("runZoneGuarded error is $error | trace: $sTrace");
        // FirebaseCrashlytics.instance.recordError(error, stack));
        // debug error
      },
    );
  }
}
