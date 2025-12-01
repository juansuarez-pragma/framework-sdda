import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/orders_repository.dart';
import '../entities/order.dart';

/// Caso de uso para get order.
///
/// Retorna [Either<Failure, Order>].
@lazySingleton
class GetOrderUseCase implements UseCase<Order, GetOrderParams> {
  final OrdersRepository _repository;

  /// Crea una instancia de [GetOrderUseCase].
  GetOrderUseCase(this._repository);

  @override
  Future<Either<Failure, Order>> call(GetOrderParams params) async {
    // Validaciones

    // Delegación al repository
    return _repository.getOrder(id: params.id);
  }
}

/// Parámetros para [GetOrderUseCase].
class GetOrderParams extends Equatable {
  /// id
  final String id;

  const GetOrderParams({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
