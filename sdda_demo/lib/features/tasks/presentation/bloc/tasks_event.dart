import 'package:equatable/equatable.dart';

/// Eventos del TasksBloc.
sealed class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

/// Solicita cargar todas las tareas
class LoadTasks extends TasksEvent {
  const LoadTasks();
}

/// Solicita refrescar las tareas
class RefreshTasks extends TasksEvent {
  const RefreshTasks();
}

/// Solicita crear una nueva tarea
class CreateTask extends TasksEvent {
  final String title;
  final String description;

  const CreateTask({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}
