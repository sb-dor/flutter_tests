import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/authentication/widget/authentication_widget.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/initialization/widget/app_widget.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/features/initialization/widget/multi_bp_scope.dart';

import 'composition_root.dart';

class AppRunnerIo {
  Future<void> init() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();

    binding.deferFirstFrame();
    try {

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

      // init app dependencies and all necessary things here
      final compositionResult = await CompositionRoot().composeResult();

      runApp(
        MultiBlocProviderScope(
          compositionResult: compositionResult,
          child: const AppWidget(
            screen: AuthenticationWidget(),
          ),
        ),
      );
    } catch (error, stackTrace) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace));
      // catch problems here
      rethrow;
    } finally {
      binding.allowFirstFrame();
    }
  }
}
