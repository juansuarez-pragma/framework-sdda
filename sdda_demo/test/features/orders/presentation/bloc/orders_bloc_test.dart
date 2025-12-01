import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/core/usecases/usecase.dart';
import 'package:sdda_demo/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:sdda_demo/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:sdda_demo/features/orders/domain/usecases/get_order_usecase.dart';
import 'package:sdda_demo/features/orders/domain/entities/order.dart';
import 'package:sdda_demo/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:sdda_demo/features/orders/presentation/bloc/orders_event.dart';
import 'package:sdda_demo/features/orders/presentation/bloc/orders_state.dart';

class MockCreateOrderUseCase extends Mock implements CreateOrderUseCase {}
class MockGetOrderUseCase extends Mock implements GetOrderUseCase {}
class MockCancelOrderUseCase extends Mock implements CancelOrderUseCase {}

void main() {
  late OrdersBloc sut;
  late MockCreateOrderUseCase mockCreateOrderUseCase;
  late MockGetOrderUseCase mockGetOrderUseCase;
  late MockCancelOrderUseCase mockCancelOrderUseCase;
  final tOrder = Order(
    id: '1',
    items: const [],
    total: 0,
    createdAt: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(const GetOrderParams(id: 'x'));
    registerFallbackValue(const CreateOrderParams(items: []));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockCreateOrderUseCase = MockCreateOrderUseCase();
    mockGetOrderUseCase = MockGetOrderUseCase();
    mockCancelOrderUseCase = MockCancelOrderUseCase();
    sut = OrdersBloc(
      mockCreateOrderUseCase,
      mockGetOrderUseCase,
      mockCancelOrderUseCase,
    );
  });

  test('estado inicial es OrdersInitial', () {
    expect(sut.state, const OrdersInitial());
  });

  group('LoadOrders', () {
    blocTest<OrdersBloc, OrdersState>(
      'emite [Loading, Loaded] cuando es exitoso',
      build: () {
        when(() => mockGetOrderUseCase(any()))
            .thenAnswer((_) async => Right<Failure, Order>(tOrder));
        return sut;
      },
      act: (bloc) => bloc.add(const LoadOrders()),
      expect: () => [
        const OrdersLoading(),
        const OrdersLoaded(),
      ],
    );

    blocTest<OrdersBloc, OrdersState>(
      'emite [Loading, Error] cuando falla',
      build: () {
        when(() => mockGetOrderUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        return sut;
      },
      act: (bloc) => bloc.add(const LoadOrders()),
      expect: () => [
        const OrdersLoading(),
        const OrdersError('error'),
      ],
    );
  });

  group('CreateOrderEvent', () {
    blocTest<OrdersBloc, OrdersState>(
      'emite [Loading, Loaded] cuando crea con éxito',
      build: () {
        when(() => mockCreateOrderUseCase(any()))
            .thenAnswer((_) async => Right<Failure, Order>(tOrder));
        return sut;
      },
      act: (bloc) => bloc.add(const CreateOrderEvent(id: '1')),
      expect: () => [
        const OrdersLoading(),
        const OrdersLoaded(),
      ],
    );

    blocTest<OrdersBloc, OrdersState>(
      'emite [Loading, Error] cuando falla la creación',
      build: () {
        when(() => mockCreateOrderUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        return sut;
      },
      act: (bloc) => bloc.add(const CreateOrderEvent(id: '1')),
      expect: () => [
        const OrdersLoading(),
        const OrdersError('error'),
      ],
    );
  });

    blocTest<OrdersBloc, OrdersState>(
      'RefreshOrders emite [Loading, Loaded]',
      build: () {
        when(() => mockGetOrderUseCase(any()))
            .thenAnswer((_) async => Right<Failure, Order>(tOrder));
        return sut;
      },
      act: (bloc) => bloc.add(const RefreshOrders()),
      expect: () => [
        const OrdersLoading(),
        const OrdersLoaded(),
      ],
    );
}
