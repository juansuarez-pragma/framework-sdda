import '../../domain/entities/task.dart';

/// DataSource local para tasks.
abstract class TasksLocalDataSource {
  /// Obtiene las tareas cacheadas.
  Future<List<Task>> getCachedTasks();

  /// Guarda las tareas en caché.
  Future<void> cacheTasks(List<Task> tasks);

  /// Limpia el caché.
  Future<void> clearCache();
}

/// Implementación del DataSource local.
// @LazySingleton(as: TasksLocalDataSource)
class TasksLocalDataSourceImpl implements TasksLocalDataSource {
  final List<Task> _cache = [];

  @override
  Future<List<Task>> getCachedTasks() async {
    return List.from(_cache);
  }

  @override
  Future<void> cacheTasks(List<Task> tasks) async {
    _cache
      ..clear()
      ..addAll(tasks);
  }

  @override
  Future<void> clearCache() async {
    _cache.clear();
  }
}
