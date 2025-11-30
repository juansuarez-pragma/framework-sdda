// ═══════════════════════════════════════════════════════════════════════════════
// CONTRATO: AuthBloc Tests
// ═══════════════════════════════════════════════════════════════════════════════
//
// Este archivo define el CONTRATO que debe cumplir AuthBloc.
// La implementación generada por IA DEBE pasar todos estos tests.
//
// Ubicación del código a generar:
// lib/features/auth/presentation/bloc/auth_bloc.dart
// lib/features/auth/presentation/bloc/auth_event.dart
// lib/features/auth/presentation/bloc/auth_state.dart
//
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Imports del proyecto (ajustar según estructura real)
// import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:app/features/auth/presentation/bloc/auth_event.dart';
// import 'package:app/features/auth/presentation/bloc/auth_state.dart';
// import 'package:app/features/auth/domain/usecases/login_usecase.dart';
// import 'package:app/features/auth/domain/usecases/logout_usecase.dart';
// import 'package:app/features/auth/domain/entities/user.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// MOCKS
// ═══════════════════════════════════════════════════════════════════════════════

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

// ═══════════════════════════════════════════════════════════════════════════════
// TESTS
// ═══════════════════════════════════════════════════════════════════════════════

void main() {
  late AuthBloc sut;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST DATA
  // ═══════════════════════════════════════════════════════════════════════════

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tName = 'Test User';

  final tUser = User(
    id: '1',
    email: tEmail,
    name: tName,
    createdAt: DateTime(2024, 1, 1),
  );

  const tServerFailure = ServerFailure('Error del servidor');
  const tInvalidCredentialsFailure = InvalidCredentialsFailure();

  // ═══════════════════════════════════════════════════════════════════════════
  // SETUP
  // ═══════════════════════════════════════════════════════════════════════════

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();

    sut = AuthBloc(
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
    );
  });

  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
    registerFallbackValue(const NoParams());
  });

  tearDown(() {
    sut.close();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST: ESTADO INICIAL
  // ═══════════════════════════════════════════════════════════════════════════

  test('estado inicial debe ser AuthInitial', () {
    expect(sut.state, const AuthInitial());
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // TESTS: LOGIN
  // ═══════════════════════════════════════════════════════════════════════════

  group('LoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emite [AuthLoading, AuthAuthenticated] cuando login es exitoso',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => Right(tUser));
        return sut;
      },
      act: (bloc) => bloc.add(const LoginRequested(
        email: tEmail,
        password: tPassword,
      )),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(user: tUser),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(const LoginParams(
              email: tEmail,
              password: tPassword,
            ))).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emite [AuthLoading, AuthError] cuando credenciales son inválidas',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => const Left(tInvalidCredentialsFailure));
        return sut;
      },
      act: (bloc) => bloc.add(const LoginRequested(
        email: tEmail,
        password: tPassword,
      )),
      expect: () => [
        const AuthLoading(),
        const AuthError(message: 'Credenciales inválidas'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emite [AuthLoading, AuthError] cuando servidor falla',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => const Left(tServerFailure));
        return sut;
      },
      act: (bloc) => bloc.add(const LoginRequested(
        email: tEmail,
        password: tPassword,
      )),
      expect: () => [
        const AuthLoading(),
        const AuthError(message: 'Error del servidor'),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // TESTS: LOGOUT
  // ═══════════════════════════════════════════════════════════════════════════

  group('LogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emite [AuthLoading, AuthUnauthenticated] cuando logout es exitoso',
      build: () {
        when(() => mockLogoutUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        return sut;
      },
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
      verify: (_) {
        verify(() => mockLogoutUseCase(const NoParams())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emite [AuthLoading, AuthUnauthenticated] incluso cuando servidor falla',
      build: () {
        when(() => mockLogoutUseCase(any()))
            .thenAnswer((_) async => const Left(tServerFailure));
        return sut;
      },
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [
        const AuthLoading(),
        // Aún así debe ir a Unauthenticated para limpiar estado local
        const AuthUnauthenticated(),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // TESTS: CHECK AUTH STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  group('CheckAuthStatusRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emite [AuthLoading, AuthAuthenticated] cuando hay usuario en caché',
      build: () {
        when(() => mockGetCurrentUserUseCase(any()))
            .thenAnswer((_) async => Right(tUser));
        return sut;
      },
      act: (bloc) => bloc.add(const CheckAuthStatusRequested()),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(user: tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emite [AuthLoading, AuthUnauthenticated] cuando no hay usuario',
      build: () {
        when(() => mockGetCurrentUserUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        return sut;
      },
      act: (bloc) => bloc.add(const CheckAuthStatusRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // TESTS: EVENTS EQUATABLE
  // ═══════════════════════════════════════════════════════════════════════════

  group('AuthEvent equality', () {
    test('LoginRequested con mismos valores deben ser iguales', () {
      const event1 = LoginRequested(email: tEmail, password: tPassword);
      const event2 = LoginRequested(email: tEmail, password: tPassword);
      expect(event1, equals(event2));
    });

    test('LogoutRequested deben ser iguales', () {
      const event1 = LogoutRequested();
      const event2 = LogoutRequested();
      expect(event1, equals(event2));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // TESTS: STATES EQUATABLE
  // ═══════════════════════════════════════════════════════════════════════════

  group('AuthState equality', () {
    test('AuthInitial deben ser iguales', () {
      const state1 = AuthInitial();
      const state2 = AuthInitial();
      expect(state1, equals(state2));
    });

    test('AuthAuthenticated con mismo user deben ser iguales', () {
      final state1 = AuthAuthenticated(user: tUser);
      final state2 = AuthAuthenticated(user: tUser);
      expect(state1, equals(state2));
    });

    test('AuthError con mismo mensaje deben ser iguales', () {
      const state1 = AuthError(message: 'error');
      const state2 = AuthError(message: 'error');
      expect(state1, equals(state2));
    });
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// PLACEHOLDER CLASSES
// ═══════════════════════════════════════════════════════════════════════════════

// Events
abstract class AuthEvent {
  const AuthEvent();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginRequested &&
          email == other.email &&
          password == other.password;

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LogoutRequested;

  @override
  int get hashCode => runtimeType.hashCode;
}

class CheckAuthStatusRequested extends AuthEvent {
  const CheckAuthStatusRequested();
}

// States
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthLoading;

  @override
  int get hashCode => runtimeType.hashCode;
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAuthenticated && user.id == other.user.id;

  @override
  int get hashCode => user.hashCode;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthUnauthenticated;

  @override
  int get hashCode => runtimeType.hashCode;
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthError && message == other.message;

  @override
  int get hashCode => message.hashCode;
}

// BLoC placeholder
class AuthBloc {
  AuthState state = const AuthInitial();

  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  });

  void add(AuthEvent event) {}
  void close() {}
}

// UseCases placeholders
class LoginUseCase {
  Future<Either<Failure, User>> call(LoginParams params) async {
    throw UnimplementedError();
  }
}

class LogoutUseCase {
  Future<Either<Failure, void>> call(NoParams params) async {
    throw UnimplementedError();
  }
}

class GetCurrentUserUseCase {
  Future<Either<Failure, User?>> call(NoParams params) async {
    throw UnimplementedError();
  }
}

// Otros placeholders
class LoginParams {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
}

class NoParams {
  const NoParams();
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

class ServerFailure extends Failure {
  final String message;
  const ServerFailure(this.message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure();
}
