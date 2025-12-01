import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/error/failures.dart';
import '../entities/task.dart';

/// Contrato del repositorio de tasks.
///
/// Define las operaciones disponibles sin detalles de implementación.
abstract class TasksRepository {
  /// Obtiene todas las tareas
  Future<Either<Failure, List<Task>>> getTasks();

  /// Obtiene una tarea por ID
  Future<Either<Failure, Task>> getById(String id);

  /// Crea una nueva tarea
  Future<Either<Failure, Task>> createTask({
    required String title,
    required String description,
  });

  /// Actualiza una tarea existente
  Future<Either<Failure, Task>> updateTask(Task task);

  /// Elimina una tarea
  Future<Either<Failure, void>> deleteTask(String id);
}
