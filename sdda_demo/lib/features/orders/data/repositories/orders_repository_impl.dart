import 'package:dartz/dartz.dart' hide Order;
import 'package:injectable/injectable.dart' hide Order;

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../datasources/orders_remote_datasource.dart';
import '../datasources/orders_local_datasource.dart';

/// Implementación del repositorio de orders.
@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;
  final OrdersLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  OrdersRepositoryImpl({
    required OrdersRemoteDataSource remoteDataSource,
    required OrdersLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  :
       _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, Order>> createOrder({required List<OrderItem> items}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    // Stub: retornar éxito con orden vacía. Reemplazar cuando se integre la API.
    return Right(
      Order(
        id: 'temp',
        items: items,
        total: 0,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<Either<Failure, Order>> getOrder({required String id}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    return Right(
      Order(
        id: id,
        items: const [],
        total: 0,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> cancelOrder({required String id}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    return const Right(null);
  }
}
