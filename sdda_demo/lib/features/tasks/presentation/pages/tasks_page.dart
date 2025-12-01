import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_state.dart';

/// Página principal del feature Tasks.
class TasksPage extends StatelessWidget {
  static const routeName = '/tasks';

  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          return switch (state) {
            TasksInitial() => const Center(
              child: Text('Inicial'),
            ),
            TasksLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            TasksLoaded() => const Center(
              child: Text('Cargado'),
            ),
            TasksError(:final message) => Center(
              child: Text(message),
            ),
          };
        },
      ),
    );
  }
}
