import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/demo_repository.dart';
import '../datasources/demo_remote_datasource.dart';
import '../datasources/demo_local_datasource.dart';

/// Implementación del repositorio de demo.
@LazySingleton(as: DemoRepository)
class DemoRepositoryImpl implements DemoRepository {
  final DemoRemoteDataSource _remoteDataSource;
  final DemoLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  DemoRepositoryImpl({
    required DemoRemoteDataSource remoteDataSource,
    required DemoLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  :
       _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, void>> loadDemo() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    try {
      // Implementar llamada a datasource cuando se defina la API.
      throw UnimplementedError();
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createDemo({required String title}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    try {
      // Implementar creación remota/local cuando se defina la API.
      throw UnimplementedError();
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> refreshDemo() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    try {
      // Implementar refresco de datos según estrategia de sincronización.
      throw UnimplementedError();
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }
}
