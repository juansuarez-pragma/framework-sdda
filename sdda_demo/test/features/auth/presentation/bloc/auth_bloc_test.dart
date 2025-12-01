import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/core/usecases/usecase.dart';
import 'package:sdda_demo/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:sdda_demo/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:sdda_demo/features/auth/domain/usecases/login_usecase.dart';
import 'package:sdda_demo/features/auth/domain/usecases/logout_usecase.dart';
import 'package:sdda_demo/features/auth/domain/usecases/register_usecase.dart';
import 'package:sdda_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sdda_demo/features/auth/presentation/bloc/auth_event.dart';
import 'package:sdda_demo/features/auth/presentation/bloc/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockCheckAuthStatusUseCase extends Mock implements CheckAuthStatusUseCase {}

void main() {
  late AuthBloc sut;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
    sut = AuthBloc(
      mockLoginUseCase,
      mockLogoutUseCase,
      mockGetCurrentUserUseCase,
      mockRegisterUseCase,
      mockCheckAuthStatusUseCase,
    );
  });

  test('estado inicial es AuthInitial', () {
    expect(sut.state, const AuthInitial());
  });

  group('LoadAuth', () {
    blocTest<AuthBloc, AuthState>(
      'emite [Loading, Loaded] cuando es exitoso',
      build: () {
        when(() => mockCheckAuthStatusUseCase(any()))
            .thenAnswer((_) async => const Right(true));
        return sut;
      },
      act: (bloc) => bloc.add(const LoadAuth()),
      expect: () => [
        const AuthLoading(),
        const AuthLoaded(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emite [Loading, Error] cuando falla',
      build: () {
        when(() => mockCheckAuthStatusUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        return sut;
      },
      act: (bloc) => bloc.add(const LoadAuth()),
      expect: () => [
        const AuthLoading(),
        const AuthError('error'),
      ],
    );
  });
}
