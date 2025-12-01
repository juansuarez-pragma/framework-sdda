import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/core/usecases/usecase.dart';
import 'package:sdda_demo/features/demo/domain/repositories/demo_repository.dart';
import 'package:sdda_demo/features/demo/domain/usecases/load_demo_usecase.dart';

class MockDemoRepository extends Mock implements DemoRepository {}

void main() {
  late LoadDemoUseCase sut;
  late MockDemoRepository mockRepository;

  // Test data
  const tFailure = ServerFailure('Error de prueba');

  setUp(() {
    mockRepository = MockDemoRepository();
    sut = LoadDemoUseCase(mockRepository);
  });

  group('LoadDemoUseCase', () {
    group('casos de éxito', () {
      test('debe retornar void cuando la operación es exitosa', () async {
        // Arrange
        when(() => mockRepository.loadDemo(
        )).thenAnswer((_) async => const Right(null));

        // Act
        final result = await sut(const NoParams());

        // Assert
        expect(result, const Right(null));
        verify(() => mockRepository.loadDemo(
        )).called(1);
      });
    });

    group('casos de error', () {
      test('debe retornar Failure cuando el repository falla', () async {
        // Arrange
        when(() => mockRepository.loadDemo(
        )).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await sut(const NoParams());

        // Assert
        expect(result, const Left(tFailure));
      });
    });
  });
}
