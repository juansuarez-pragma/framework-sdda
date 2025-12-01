import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';

/// Estados del TasksBloc.
sealed class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class TasksInitial extends TasksState {
  const TasksInitial();
}

/// Cargando datos
class TasksLoading extends TasksState {
  const TasksLoading();
}

/// Datos cargados exitosamente
class TasksLoaded extends TasksState {
  final List<Task> tasks;

  const TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

/// Error al cargar datos
class TasksError extends TasksState {
  final String message;

  const TasksError(this.message);

  @override
  List<Object?> get props => [message];
}
