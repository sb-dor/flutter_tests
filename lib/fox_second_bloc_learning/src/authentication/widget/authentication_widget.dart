import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/bloc/authentication_events.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/authentication/bloc/authentication_states.dart';
import 'package:flutter_tests/fox_second_bloc_learning/src/post/widgets/post_page.dart';

class AuthenticationWidget extends StatefulWidget {
  const AuthenticationWidget({super.key});

  @override
  State<AuthenticationWidget> createState() => _AuthenticationWidgetState();
}

class _AuthenticationWidgetState extends State<AuthenticationWidget> {
  @override
  void initState() {
    super.initState();
    // you can either add event from freezed like this
    context.read<AuthenticationBloc>().add(const AuthenticationBlocEvents.checkAuth());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authentication"),
      ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationStates>(
        builder: (context, state) {
          return SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is InProgressAuthenticationState)
                  const CircularProgressIndicator()
                else
                  TextButton(
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(
                            const LogInAuthenticationEvent(
                              email: "temp_email",
                              password: "temp_password",
                            ),
                          );
                    },
                    child: const Text("auth"),
                  ),
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state is AuthenticatedState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const PostPage();
                },
              ),
              (route) {
                return false;
              },
            );
          }
        },
      ),
    );
  }
}
