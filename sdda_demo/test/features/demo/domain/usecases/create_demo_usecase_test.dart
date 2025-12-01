import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/features/demo/domain/repositories/demo_repository.dart';
import 'package:sdda_demo/features/demo/domain/usecases/create_demo_usecase.dart';

class MockDemoRepository extends Mock implements DemoRepository {}

void main() {
  late CreateDemoUseCase sut;
  late MockDemoRepository mockRepository;

  // Test data
  const tFailure = ServerFailure('Error de prueba');

  setUp(() {
    mockRepository = MockDemoRepository();
    sut = CreateDemoUseCase(mockRepository);
  });

  group('CreateDemoUseCase', () {
    group('casos de éxito', () {
      test('debe retornar void cuando la operación es exitosa', () async {
        // Arrange
        when(() => mockRepository.createDemo(title: any(named: 'title')))
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await sut(const CreateDemoParams(title: 'demo'));

        // Assert
        expect(result, const Right(null));
        verify(() => mockRepository.createDemo(title: 'demo')).called(1);
      });
    });

    group('casos de error', () {
      test('debe retornar Failure cuando el repository falla', () async {
        // Arrange
        when(() => mockRepository.createDemo(title: any(named: 'title')))
            .thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await sut(const CreateDemoParams(title: 'demo'));

        // Assert
        expect(result, const Left(tFailure));
      });
    });
  });
}
