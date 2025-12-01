import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/features/auth/domain/entities/user.dart';
import 'package:sdda_demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:sdda_demo/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUseCase sut;
  late MockAuthRepository mockRepository;

  // Test data
  final tUser = User(
    id: '1',
    email: 'test@test.com',
    name: 'Test',
    avatarUrl: null,
    createdAt: DateTime(2024, 1, 1),
  );
  const tFailure = ServerFailure('Error de prueba');

  setUp(() {
    mockRepository = MockAuthRepository();
    sut = RegisterUseCase(mockRepository);
  });

  group('RegisterUseCase', () {
    group('casos de éxito', () {
      test('debe retornar User cuando la operación es exitosa', () async {
        // Arrange
        when(() => mockRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenAnswer((_) async => Right(tUser));

        // Act
        final result = await sut(
          const RegisterParams(email: 'test@test.com', password: '123456', name: 'Test'),
        );

        // Assert
        expect(result, Right(tUser));
        verify(() => mockRepository.register(
              email: 'test@test.com',
              password: '123456',
              name: 'Test',
            )).called(1);
      });
    });

    group('casos de error', () {
      test('debe retornar Failure cuando el repository falla', () async {
        // Arrange
        when(() => mockRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await sut(
          const RegisterParams(email: 'test@test.com', password: '123456', name: 'Test'),
        );

        // Assert
        expect(result, const Left(tFailure));
      });
    });
  });
}
