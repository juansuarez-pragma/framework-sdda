import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/orders_repository.dart';

/// Caso de uso para cancel order.
///
/// Retorna [Either<Failure, void>].
@lazySingleton
class CancelOrderUseCase implements UseCase<void, CancelOrderParams> {
  final OrdersRepository _repository;

  /// Crea una instancia de [CancelOrderUseCase].
  CancelOrderUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(CancelOrderParams params) async {
    // Validaciones

    // Delegación al repository
    return _repository.cancelOrder(id: params.id);
  }
}

/// Parámetros para [CancelOrderUseCase].
class CancelOrderParams extends Equatable {
  /// id
  final String id;

  const CancelOrderParams({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
