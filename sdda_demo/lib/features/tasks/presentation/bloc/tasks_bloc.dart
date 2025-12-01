import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

/// BLoC para gestión de Tasks.
@injectable
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasksUseCase _getTasksUseCase;
  final CreateTaskUseCase _createTaskUseCase;

  TasksBloc(
    this._getTasksUseCase,
    this._createTaskUseCase,
  ) : super(const TasksInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<RefreshTasks>(_onRefreshTasks);
    on<CreateTask>(_onCreateTask);
  }

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());

    final result = await _getTasksUseCase(const NoParams());
    result.fold(
      (failure) => emit(TasksError(failure.message)),
      (tasks) => emit(TasksLoaded(tasks)),
    );
  }

  Future<void> _onRefreshTasks(
    RefreshTasks event,
    Emitter<TasksState> emit,
  ) async {
    final result = await _getTasksUseCase(const NoParams());
    result.fold(
      (failure) => emit(TasksError(failure.message)),
      (tasks) => emit(TasksLoaded(tasks)),
    );
  }

  Future<void> _onCreateTask(
    CreateTask event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;

    final result = await _createTaskUseCase(
      CreateTaskParams(
        title: event.title,
        description: event.description,
      ),
    );

    result.fold(
      (failure) => emit(TasksError(failure.message)),
      (newTask) {
        if (currentState is TasksLoaded) {
          emit(TasksLoaded([...currentState.tasks, newTask]));
        } else {
          emit(TasksLoaded([newTask]));
        }
      },
    );
  }
}
