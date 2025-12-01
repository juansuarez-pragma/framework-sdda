import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/features/orders/domain/entities/order.dart';
import 'package:sdda_demo/features/orders/domain/entities/order_item.dart';
import 'package:sdda_demo/features/orders/domain/repositories/orders_repository.dart';
import 'package:sdda_demo/features/orders/domain/usecases/create_order_usecase.dart';

class MockOrdersRepository extends Mock implements OrdersRepository {}

void main() {
  late CreateOrderUseCase sut;
  late MockOrdersRepository mockRepository;

  // Test data
  final tOrder = Order(
    id: '1',
    items: const [],
    total: 0,
    createdAt: DateTime(2024, 1, 1),
  );
  const tItems = <OrderItem>[];
  const tFailure = ServerFailure('Error de prueba');

  setUp(() {
    mockRepository = MockOrdersRepository();
    sut = CreateOrderUseCase(mockRepository);
  });

  group('CreateOrderUseCase', () {
    group('casos de éxito', () {
      test('debe retornar Order cuando la operación es exitosa', () async {
        // Arrange
        when(() => mockRepository.createOrder(items: any(named: 'items')))
            .thenAnswer((_) async => Right<Failure, Order>(tOrder));

        // Act
        final result = await sut(const CreateOrderParams(items: tItems));

        // Assert
        expect(result, Right<Failure, Order>(tOrder));
        verify(() => mockRepository.createOrder(items: tItems)).called(1);
      });
    });

    group('casos de error', () {
      test('debe retornar Failure cuando el repository falla', () async {
        // Arrange
        when(() => mockRepository.createOrder(items: any(named: 'items')))
            .thenAnswer((_) async => const Left<Failure, Order>(tFailure));

        // Act
        final result = await sut(const CreateOrderParams(items: tItems));

        // Assert
        expect(result, const Left<Failure, Order>(tFailure));
      });
    });
  });
}
