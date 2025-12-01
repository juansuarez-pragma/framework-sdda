import 'package:equatable/equatable.dart';

/// Estados del OrdersBloc.
sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

/// Cargando datos
class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

/// Datos cargados exitosamente
class OrdersLoaded extends OrdersState {
  // Extender con payload de órdenes cuando se integre la API.

  const OrdersLoaded();

  // @override
  // List<Object?> get props => [items];
}

/// Error al cargar datos
class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}
