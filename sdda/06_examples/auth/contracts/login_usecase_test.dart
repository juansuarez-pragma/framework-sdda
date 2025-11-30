// ═══════════════════════════════════════════════════════════════════════════════
// CONTRATO: LoginUseCase Tests
// ═══════════════════════════════════════════════════════════════════════════════
//
// Este archivo define el CONTRATO que debe cumplir LoginUseCase.
// La implementación generada por IA DEBE pasar todos estos tests.
//
// Ubicación del código a generar:
// lib/features/auth/domain/usecases/login_usecase.dart
//
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Imports del proyecto (ajustar según estructura real)
// import 'package:app/core/error/failures.dart';
// import 'package:app/features/auth/domain/entities/user.dart';
// import 'package:app/features/auth/domain/repositories/auth_repository.dart';
// import 'package:app/features/auth/domain/usecases/login_usecase.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// MOCKS
// ═══════════════════════════════════════════════════════════════════════════════

class MockAuthRepository extends Mock implements AuthRepository {}

// ═══════════════════════════════════════════════════════════════════════════════
// TESTS
// ═══════════════════════════════════════════════════════════════════════════════

void main() {
  late LoginUseCase sut;
  late MockAuthRepository mockRepository;

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST DATA
  // ═══════════════════════════════════════════════════════════════════════════

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tInvalidEmail = '';
  const tShortPassword = '123';

  final tUser = User(
    id: '1',
    email: tEmail,
    name: 'Test User',
    createdAt: DateTime(2024, 1, 1),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SETUP
  // ═══════════════════════════════════════════════════════════════════════════

  setUp(() {
    mockRepository = MockAuthRepository();
    sut = LoginUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // TESTS: CASOS DE ÉXITO
  // ═══════════════════════════════════════════════════════════════════════════

  group('LoginUseCase', () {
    group('casos de éxito', () {
      test('debe retornar User cuando las credenciales son válidas', () async {
        // Arrange
        when(() => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(tUser));

        // Act
        final result = await sut(const LoginParams(
          email: tEmail,
          password: tPassword,
        ));

        // Assert
        expect(result, Right(tUser));
      });

      test('debe llamar al repository exactamente una vez', () async {
        // Arrange
        when(() => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(tUser));

        // Act
        await sut(const LoginParams(email: tEmail, password: tPassword));

        // Assert
        verify(() => mockRepository.login(
              email: tEmail,
              password: tPassword,
            )).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('debe pasar los parámetros correctos al repository', () async {
        // Arrange
        when(() => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(tUser));

        // Act
        await sut(const LoginParams(email: tEmail, password: tPassword));

        // Assert
        verify(() => mockRepository.login(
              email: tEmail,
              password: tPassword,
            ));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // TESTS: CASOS DE ERROR
    // ═══════════════════════════════════════════════════════════════════════

    group('casos de error', () {
      test(
          'debe retornar InvalidCredentialsFailure cuando credenciales son incorrectas',
          () async {
        // Arrange
        when(() => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer(
                (_) async => const Left(InvalidCredentialsFailure()));

        // Act
        final result = await sut(const LoginParams(
          email: tEmail,
          password: tPassword,
        ));

        // Assert
        expect(result, const Left(InvalidCredentialsFailure()));
      });

      test('debe retornar NetworkFailure cuando no hay conexión', () async {
        // Arrange
        when(() => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Left(NetworkFailure()));

        // Act
        final result = await sut(const LoginParams(
          email: tEmail,
          password: tPassword,
        ));

        // Assert
        expect(result, const Left(NetworkFailure()));
      });

      test('debe retornar ServerFailure cuando el servidor falla', () async {
        // Arrange
        const tServerFailure = ServerFailure('Error interno del servidor');
        when(() => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Left(tServerFailure));

        // Act
        final result = await sut(const LoginParams(
          email: tEmail,
          password: tPassword,
        ));

        // Assert
        expect(result, const Left(tServerFailure));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // TESTS: VALIDACIONES
    // ═══════════════════════════════════════════════════════════════════════

    group('validaciones', () {
      test('debe retornar ValidationFailure cuando email está vacío', () async {
        // Act
        final result = await sut(const LoginParams(
          email: tInvalidEmail,
          password: tPassword,
        ));

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (_) => fail('Debería retornar failure'),
        );

        // No debe llamar al repository
        verifyNever(() => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ));
      });

      test(
          'debe retornar ValidationFailure cuando password tiene menos de 6 caracteres',
          () async {
        // Act
        final result = await sut(const LoginParams(
          email: tEmail,
          password: tShortPassword,
        ));

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (_) => fail('Debería retornar failure'),
        );

        // No debe llamar al repository
        verifyNever(() => mockRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ));
      });

      test('debe retornar ValidationFailure cuando email no contiene @',
          () async {
        // Act
        final result = await sut(const LoginParams(
          email: 'invalidemail',
          password: tPassword,
        ));

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (_) => fail('Debería retornar failure'),
        );
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // TESTS: EQUATABLE
    // ═══════════════════════════════════════════════════════════════════════

    group('LoginParams', () {
      test('dos LoginParams con mismos valores deben ser iguales', () {
        // Arrange
        const params1 = LoginParams(email: tEmail, password: tPassword);
        const params2 = LoginParams(email: tEmail, password: tPassword);

        // Assert
        expect(params1, equals(params2));
      });

      test('dos LoginParams con diferentes valores no deben ser iguales', () {
        // Arrange
        const params1 = LoginParams(email: tEmail, password: tPassword);
        const params2 = LoginParams(email: 'other@email.com', password: tPassword);

        // Assert
        expect(params1, isNot(equals(params2)));
      });

      test('props debe contener email y password', () {
        // Arrange
        const params = LoginParams(email: tEmail, password: tPassword);

        // Assert
        expect(params.props, [tEmail, tPassword]);
      });
    });
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// PLACEHOLDER CLASSES (para que el archivo compile)
// En el proyecto real, estas vendrían de los imports
// ═══════════════════════════════════════════════════════════════════════════════

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
}

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<Either<Failure, User>> call(LoginParams params) async {
    // Validaciones
    if (params.email.isEmpty) {
      return const Left(ValidationFailure('El email es requerido'));
    }
    if (!params.email.contains('@')) {
      return const Left(ValidationFailure('Email inválido'));
    }
    if (params.password.length < 6) {
      return const Left(ValidationFailure('La contraseña debe tener mínimo 6 caracteres'));
    }

    return _repository.login(email: params.email, password: params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  List<Object?> get props => [email, password];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginParams &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password;

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}

class User {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
  });
}

abstract class Failure {
  const Failure();
}

class ValidationFailure extends Failure {
  final String message;
  const ValidationFailure(this.message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure();
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class ServerFailure extends Failure {
  final String message;
  const ServerFailure(this.message);
}
