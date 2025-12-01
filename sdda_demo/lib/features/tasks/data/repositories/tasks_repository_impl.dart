import 'package:dartz/dartz.dart' hide Task;
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_datasource.dart';
import '../datasources/tasks_local_datasource.dart';

/// Implementación del repositorio de tasks.
@LazySingleton(as: TasksRepository)
class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource _remoteDataSource;
  final TasksLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  TasksRepositoryImpl({
    required TasksRemoteDataSource remoteDataSource,
    required TasksLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    if (!await _networkInfo.isConnected) {
      // Intentar obtener del caché local
      try {
        final cachedTasks = await _localDataSource.getCachedTasks();
        return Right(cachedTasks);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }

    try {
      final remoteTasks = await _remoteDataSource.getTasks();
      await _localDataSource.cacheTasks(remoteTasks);
      return Right(remoteTasks);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> getById(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    try {
      final task = await _remoteDataSource.getTaskById(id);
      return Right(task);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask({
    required String title,
    required String description,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    try {
      final task = await _remoteDataSource.createTask(
        title: title,
        description: description,
      );
      return Right(task);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    try {
      final updatedTask = await _remoteDataSource.updateTask(task);
      return Right(updatedTask);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    try {
      await _remoteDataSource.deleteTask(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }
}
