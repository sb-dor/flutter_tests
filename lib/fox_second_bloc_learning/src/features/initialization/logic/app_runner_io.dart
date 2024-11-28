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
      // catch problems here
      rethrow;
    } finally {
      binding.allowFirstFrame();
    }
  }
}
