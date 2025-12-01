import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/features/orders/domain/entities/order.dart';
import 'package:sdda_demo/features/orders/domain/repositories/orders_repository.dart';
import 'package:sdda_demo/features/orders/domain/usecases/get_order_usecase.dart';

class MockOrdersRepository extends Mock implements OrdersRepository {}

void main() {
  late GetOrderUseCase sut;
  late MockOrdersRepository mockRepository;

  // Test data
  final tOrder = Order(
    id: '1',
    items: const [],
    total: 0,
    createdAt: DateTime(2024, 1, 1),
  );
  const tFailure = ServerFailure('Error de prueba');

  setUp(() {
    mockRepository = MockOrdersRepository();
    sut = GetOrderUseCase(mockRepository);
  });

  group('GetOrderUseCase', () {
    group('casos de éxito', () {
      test('debe retornar Order cuando la operación es exitosa', () async {
        // Arrange
        when(() => mockRepository.getOrder(id: any(named: 'id')))
            .thenAnswer((_) async => Right<Failure, Order>(tOrder));

        // Act
        final result = await sut(const GetOrderParams(id: '1'));

        // Assert
        expect(result, Right<Failure, Order>(tOrder));
        verify(() => mockRepository.getOrder(id: '1')).called(1);
      });
    });

    group('casos de error', () {
      test('debe retornar Failure cuando el repository falla', () async {
        // Arrange
        when(() => mockRepository.getOrder(id: any(named: 'id')))
            .thenAnswer((_) async => const Left<Failure, Order>(tFailure));

        // Act
        final result = await sut(const GetOrderParams(id: '1'));

        // Assert
        expect(result, const Left<Failure, Order>(tFailure));
      });
    });
  });
}
