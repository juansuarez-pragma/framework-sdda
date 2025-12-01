import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/cancel_order_usecase.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_order_usecase.dart';
import 'orders_event.dart';
import 'orders_state.dart';

/// BLoC para gestión de Orders.
@injectable
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final CreateOrderUseCase _createOrderUseCase;
  final GetOrderUseCase _getOrderUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;

  OrdersBloc(
    this._createOrderUseCase,
    this._getOrderUseCase,
    this._cancelOrderUseCase,
  ) : super(const OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrderEvent>(_onCreateOrder);
    on<RefreshOrders>(_onRefreshOrders);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());

    final result = await _getOrderUseCase(const GetOrderParams(id: 'sample'));
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (_) => emit(const OrdersLoaded()),
    );
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());

    final result = await _createOrderUseCase(
      const CreateOrderParams(items: []),
    );
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (_) => emit(const OrdersLoaded()),
    );
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OrdersState> emit,
  ) async {
    // Similar a load pero sin mostrar loading
    add(const LoadOrders());
  }
}
