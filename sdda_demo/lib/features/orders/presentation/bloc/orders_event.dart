import 'package:equatable/equatable.dart';

/// Eventos del OrdersBloc.
sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

/// Solicita cargar datos
class LoadOrders extends OrdersEvent {
  const LoadOrders();
}

/// Crear una orden (usa datos de ejemplo).
class CreateOrderEvent extends OrdersEvent {
  final String id;

  const CreateOrderEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Solicita refrescar datos
class RefreshOrders extends OrdersEvent {
  const RefreshOrders();
}
