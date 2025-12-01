import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

/// Caso de uso para crear una nueva tarea.
///
/// Retorna [Either<Failure, Task>].
@lazySingleton
class CreateTaskUseCase implements UseCase<Task, CreateTaskParams> {
  final TasksRepository _repository;

  /// Crea una instancia de [CreateTaskUseCase].
  CreateTaskUseCase(this._repository);

  @override
  Future<Either<Failure, Task>> call(CreateTaskParams params) async {
    return _repository.createTask(
      title: params.title,
      description: params.description,
    );
  }
}

/// Parámetros para [CreateTaskUseCase].
class CreateTaskParams extends Equatable {
  final String title;
  final String description;

  const CreateTaskParams({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}
