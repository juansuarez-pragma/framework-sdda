import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/core/usecases/usecase.dart';
import 'package:sdda_demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:sdda_demo/features/auth/domain/usecases/check_auth_status_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late CheckAuthStatusUseCase sut;
  late MockAuthRepository mockRepository;

  // Test data
  const tStatus = true;
  const tFailure = ServerFailure('Error de prueba');

  setUp(() {
    mockRepository = MockAuthRepository();
    sut = CheckAuthStatusUseCase(mockRepository);
  });

  group('CheckAuthStatusUseCase', () {
    group('casos de éxito', () {
      test('debe retornar bool cuando la operación es exitosa', () async {
        // Arrange
        when(() => mockRepository.checkAuthStatus(
        )).thenAnswer((_) async => const Right(tStatus));

        // Act
        final result = await sut(const NoParams());

        // Assert
        expect(result, const Right(tStatus));
        verify(() => mockRepository.checkAuthStatus(
        )).called(1);
      });
    });

    group('casos de error', () {
      test('debe retornar Failure cuando el repository falla', () async {
        // Arrange
        when(() => mockRepository.checkAuthStatus(
        )).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await sut(const NoParams());

        // Assert
        expect(result, const Left(tFailure));
      });
    });
  });
}
