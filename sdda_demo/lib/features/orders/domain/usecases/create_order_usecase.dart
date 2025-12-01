import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/orders_repository.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';

/// Caso de uso para create order.
///
/// Retorna [Either<Failure, Order>].
@lazySingleton
class CreateOrderUseCase implements UseCase<Order, CreateOrderParams> {
  final OrdersRepository _repository;

  /// Crea una instancia de [CreateOrderUseCase].
  CreateOrderUseCase(this._repository);

  @override
  Future<Either<Failure, Order>> call(CreateOrderParams params) async {
    // Validaciones

    // Delegación al repository
    return _repository.createOrder(items: params.items);
  }
}

/// Parámetros para [CreateOrderUseCase].
class CreateOrderParams extends Equatable {
  /// items
  final List<OrderItem> items;

  const CreateOrderParams({
    required this.items,
  });

  @override
  List<Object?> get props => [items];
}
