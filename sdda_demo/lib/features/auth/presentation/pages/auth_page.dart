import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

/// Página principal del feature Auth.
class AuthPage extends StatelessWidget {
  static const routeName = '/auth';

  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return switch (state) {
            AuthInitial() => const Center(
              child: Text('Inicial'),
            ),
            AuthLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            AuthLoaded() => const Center(
              child: Text('Cargado'),
            ),
            AuthError(:final message) => Center(
              child: Text(message),
            ),
          };
        },
      ),
    );
  }
}
