import '../../domain/entities/task.dart';

/// DataSource remoto para tasks.
abstract class TasksRemoteDataSource {
  /// Obtiene todas las tareas del servidor.
  Future<List<Task>> getTasks();

  /// Obtiene una tarea por ID.
  Future<Task> getTaskById(String id);

  /// Crea una nueva tarea.
  Future<Task> createTask({
    required String title,
    required String description,
  });

  /// Actualiza una tarea existente.
  Future<Task> updateTask(Task task);

  /// Elimina una tarea.
  Future<void> deleteTask(String id);
}

/// Implementación del DataSource remoto.
// @LazySingleton(as: TasksRemoteDataSource)
class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  // final ApiClient _apiClient;

  // TasksRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Task>> getTasks() async {
    // Simulación de datos para demostración
    return [
      Task(
        id: '1',
        title: 'Tarea 1',
        description: 'Descripción de la tarea 1',
        isCompleted: false,
        createdAt: DateTime.now(),
      ),
      Task(
        id: '2',
        title: 'Tarea 2',
        description: 'Descripción de la tarea 2',
        isCompleted: true,
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<Task> getTaskById(String id) async {
    return Task(
      id: id,
      title: 'Tarea $id',
      description: 'Descripción de la tarea $id',
      isCompleted: false,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<Task> createTask({
    required String title,
    required String description,
  }) async {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<Task> updateTask(Task task) async {
    return task;
  }

  @override
  Future<void> deleteTask(String id) async {
    // Simular eliminación
  }
}
