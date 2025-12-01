import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/core/usecases/usecase.dart';
import 'package:sdda_demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:sdda_demo/features/auth/domain/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase sut;
  late MockAuthRepository mockRepository;

  // Test data
  const tFailure = ServerFailure('Error de prueba');

  setUp(() {
    mockRepository = MockAuthRepository();
    sut = LogoutUseCase(mockRepository);
  });

  group('LogoutUseCase', () {
    group('casos de éxito', () {
      test('debe retornar void cuando la operación es exitosa', () async {
        // Arrange
        when(() => mockRepository.logout(
        )).thenAnswer((_) async => const Right(null));

        // Act
        final result = await sut(const NoParams());

        // Assert
        expect(result, const Right(null));
        verify(() => mockRepository.logout(
        )).called(1);
      });
    });

    group('casos de error', () {
      test('debe retornar Failure cuando el repository falla', () async {
        // Arrange
        when(() => mockRepository.logout(
        )).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await sut(const NoParams());

        // Assert
        expect(result, const Left(tFailure));
      });
    });
  });
}
