import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/features/orders/domain/repositories/orders_repository.dart';
import 'package:sdda_demo/features/orders/domain/usecases/cancel_order_usecase.dart';

class MockOrdersRepository extends Mock implements OrdersRepository {}

void main() {
  late CancelOrderUseCase sut;
  late MockOrdersRepository mockRepository;

  // Test data
  const tFailure = ServerFailure('Error de prueba');

  setUp(() {
    mockRepository = MockOrdersRepository();
    sut = CancelOrderUseCase(mockRepository);
  });

  group('CancelOrderUseCase', () {
    group('casos de éxito', () {
      test('debe retornar void cuando la operación es exitosa', () async {
        // Arrange
        when(() => mockRepository.cancelOrder(id: any(named: 'id')))
            .thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await sut(const CancelOrderParams(id: '1'));

        // Assert
        expect(result, const Right<Failure, void>(null));
        verify(() => mockRepository.cancelOrder(id: '1')).called(1);
      });
    });

    group('casos de error', () {
      test('debe retornar Failure cuando el repository falla', () async {
        // Arrange
        when(() => mockRepository.cancelOrder(id: any(named: 'id')))
            .thenAnswer((_) async => const Left<Failure, void>(tFailure));

        // Act
        final result = await sut(const CancelOrderParams(id: '1'));

        // Assert
        expect(result, const Left<Failure, void>(tFailure));
      });
    });
  });
}
