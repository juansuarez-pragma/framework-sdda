import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/core/usecases/usecase.dart';
import 'package:sdda_demo/features/demo/domain/usecases/create_demo_usecase.dart';
import 'package:sdda_demo/features/demo/domain/usecases/load_demo_usecase.dart';
import 'package:sdda_demo/features/demo/domain/usecases/refresh_demo_usecase.dart';
import 'package:sdda_demo/features/demo/presentation/bloc/demo_bloc.dart';
import 'package:sdda_demo/features/demo/presentation/bloc/demo_event.dart';
import 'package:sdda_demo/features/demo/presentation/bloc/demo_state.dart';

class MockLoadDemoUseCase extends Mock implements LoadDemoUseCase {}
class MockCreateDemoUseCase extends Mock implements CreateDemoUseCase {}
class MockRefreshDemoUseCase extends Mock implements RefreshDemoUseCase {}

void main() {
  late DemoBloc sut;
  late MockLoadDemoUseCase mockLoadDemoUseCase;
  late MockCreateDemoUseCase mockCreateDemoUseCase;
  late MockRefreshDemoUseCase mockRefreshDemoUseCase;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const CreateDemoParams(title: 'fallback'));
  });

  setUp(() {
    mockLoadDemoUseCase = MockLoadDemoUseCase();
    mockCreateDemoUseCase = MockCreateDemoUseCase();
    mockRefreshDemoUseCase = MockRefreshDemoUseCase();
    sut = DemoBloc(
      mockLoadDemoUseCase,
      mockCreateDemoUseCase,
      mockRefreshDemoUseCase,
    );
  });

  test('estado inicial es DemoInitial', () {
    expect(sut.state, const DemoInitial());
  });

  group('LoadDemo', () {
    blocTest<DemoBloc, DemoState>(
      'emite [Loading, Loaded] cuando es exitoso',
      build: () {
        when(() => mockLoadDemoUseCase(const NoParams()))
            .thenAnswer((_) async => const Right(null));
        return sut;
      },
      act: (bloc) => bloc.add(const LoadDemo()),
      expect: () => [
        const DemoLoading(),
        const DemoLoaded(),
      ],
    );

    blocTest<DemoBloc, DemoState>(
      'emite [Loading, Error] cuando falla',
      build: () {
        when(() => mockLoadDemoUseCase(const NoParams()))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        return sut;
      },
      act: (bloc) => bloc.add(const LoadDemo()),
      expect: () => [
        const DemoLoading(),
        const DemoError('error'),
      ],
    );
  });

  group('RefreshDemo', () {
    blocTest<DemoBloc, DemoState>(
      'emite [Loaded] cuando refresca con éxito',
      build: () {
        when(() => mockRefreshDemoUseCase(const NoParams()))
            .thenAnswer((_) async => const Right(null));
        return sut;
      },
      act: (bloc) => bloc.add(const RefreshDemo()),
      expect: () => [
        const DemoLoaded(),
      ],
    );

    blocTest<DemoBloc, DemoState>(
      'emite [Error] cuando falla el refresh',
      build: () {
        when(() => mockRefreshDemoUseCase(const NoParams()))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        return sut;
      },
      act: (bloc) => bloc.add(const RefreshDemo()),
      expect: () => [
        const DemoError('error'),
      ],
    );
  });

  group('CreateDemo', () {
    blocTest<DemoBloc, DemoState>(
      'emite [Loading, Loaded] cuando crea con éxito',
      build: () {
        when(() => mockCreateDemoUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        return sut;
      },
      act: (bloc) => bloc.add(const CreateDemo(title: 'demo')),
      expect: () => [
        const DemoLoading(),
        const DemoLoaded(),
      ],
      verify: (_) {
        verify(() => mockCreateDemoUseCase(
              const CreateDemoParams(title: 'demo'),
            )).called(1);
      },
    );

    blocTest<DemoBloc, DemoState>(
      'emite [Loading, Error] cuando falla la creación',
      build: () {
        when(() => mockCreateDemoUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        return sut;
      },
      act: (bloc) => bloc.add(const CreateDemo(title: 'demo')),
      expect: () => [
        const DemoLoading(),
        const DemoError('error'),
      ],
    );
  });
}
