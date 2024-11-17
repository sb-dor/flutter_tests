import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tests/add_to_cart_test/feature/home/view/bloc/home_bloc.dart';
import 'package:flutter_tests/add_to_cart_test/feature/initialization/logic/composition_root.dart';
import 'package:provider/provider.dart';

class BlocMultiProvideHelper extends StatelessWidget {
  final Widget child;
  final CompositionResult compositionResult;

  const BlocMultiProvideHelper({
    super.key,
    required this.child,
    required this.compositionResult,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (_) => compositionResult.dependencyContainer.homeBloc,
        ),
        BlocProvider(
          create: (_) => compositionResult.dependencyContainer.cartBloc,
        ),
      ],
      child: child,
    );
  }
}
