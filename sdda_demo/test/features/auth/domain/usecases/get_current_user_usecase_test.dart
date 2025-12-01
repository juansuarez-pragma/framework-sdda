import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/core/usecases/usecase.dart';
import 'package:sdda_demo/features/auth/domain/entities/user.dart';
import 'package:sdda_demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:sdda_demo/features/auth/domain/usecases/get_current_user_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetCurrentUserUseCase sut;
  late MockAuthRepository mockRepository;

  // Test data
  final User? tUser = User(
    id: '1',
    email: 'test@test.com',
    name: 'Test',
    avatarUrl: null,
    createdAt: DateTime(2024, 1, 1),
  );
  const tFailure = ServerFailure('Error de prueba');

  setUp(() {
    mockRepository = MockAuthRepository();
    sut = GetCurrentUserUseCase(mockRepository);
  });

  group('GetCurrentUserUseCase', () {
    group('casos de éxito', () {
      test('debe retornar User? cuando la operación es exitosa', () async {
        // Arrange
        when(() => mockRepository.getCurrentUser(
        )).thenAnswer((_) async => Right(tUser));

        // Act
        final result = await sut(const NoParams());

        // Assert
        expect(result, Right(tUser));
        verify(() => mockRepository.getCurrentUser(
        )).called(1);
      });
    });

    group('casos de error', () {
      test('debe retornar Failure cuando el repository falla', () async {
        // Arrange
        when(() => mockRepository.getCurrentUser(
        )).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await sut(const NoParams());

        // Assert
        expect(result, const Left(tFailure));
      });
    });
  });
}
