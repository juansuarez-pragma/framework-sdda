import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

/// Caso de uso para obtener todas las tareas.
///
/// Retorna [Either<Failure, List<Task>>].
@lazySingleton
class GetTasksUseCase implements UseCase<List<Task>, NoParams> {
  final TasksRepository _repository;

  /// Crea una instancia de [GetTasksUseCase].
  GetTasksUseCase(this._repository);

  @override
  Future<Either<Failure, List<Task>>> call(NoParams params) async {
    return _repository.getTasks();
  }
}
