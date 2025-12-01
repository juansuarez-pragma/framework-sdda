import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';

/// Contrato del repositorio de orders.
///
/// Define las operaciones disponibles sin detalles de implementación.
abstract class OrdersRepository {

  /// null
  Future<Either<Failure, Order>> createOrder({required List<OrderItem> items});

  /// null
  Future<Either<Failure, Order>> getOrder({required String id});

  /// null
  Future<Either<Failure, void>> cancelOrder({required String id});
}
