import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'runner_stub.dart'
    if (dart.library.io) 'runner_io.dart'
    if (dart.library.html) 'runner_web.dart' as runner;

// all errors that may happen in the future
// will be handled inside runZonedGuarded (widget errors, functions error, request errors)
// but not bloc errors, because bloc's error will be send to the Bloc.observer
// that is why you have to write a code that handles bloc's errors and sends to the server
void main() => runZonedGuarded(
      () {
        Bloc.observer = FoxSecondBlocObserver.instance;

        // default is sequential
        // all of them will be set in queue by default
        // if user clicked Login then Logout
        // first works when Login ends then Logout will work (Logout will not work until Login finished)
        Bloc.transformer = sequential();

        runner.run();
      },
      (error, stackTrace) {
        // error report
      },
    );

class FoxSecondBlocObserver extends BlocObserver {
  static FoxSecondBlocObserver get instance => _instance ??= FoxSecondBlocObserver._();
  static FoxSecondBlocObserver? _instance;

  FoxSecondBlocObserver._();

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // send bloc error to crashlytics or to your own server
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // which event from which bloc was called
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    // which bloc was closed
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    // which bloc was created
  }
}
