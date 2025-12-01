import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/demo_bloc.dart';
import '../bloc/demo_event.dart';
import '../bloc/demo_state.dart';

/// Página principal del feature Demo.
class DemoPage extends StatelessWidget {
  static const routeName = '/demo';

  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<DemoBloc, DemoState>(
              builder: (context, state) {
                return switch (state) {
                  DemoInitial() => const Text('Estado: Inicial'),
                  DemoLoading() => const LinearProgressIndicator(),
                  DemoLoaded() => const Text('Estado: Cargado'),
                  DemoError(:final message) => Text('Error: $message'),
                };
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<DemoBloc>().add(const LoadDemo());
              },
              child: const Text('Cargar'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<DemoBloc>().add(const CreateDemo(title: 'demo'));
              },
              child: const Text('Crear'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                context.read<DemoBloc>().add(const RefreshDemo());
              },
              child: const Text('Refrescar'),
            ),
          ],
        ),
      ),
    );
  }
}
