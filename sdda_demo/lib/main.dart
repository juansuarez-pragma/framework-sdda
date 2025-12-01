import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/demo/domain/repositories/demo_repository.dart';
import 'features/demo/domain/usecases/create_demo_usecase.dart';
import 'features/demo/domain/usecases/load_demo_usecase.dart';
import 'features/demo/domain/usecases/refresh_demo_usecase.dart';
import 'features/demo/presentation/bloc/demo_bloc.dart';
import 'features/demo/presentation/pages/demo_page.dart';
import 'core/error/failures.dart';
import 'package:dartz/dartz.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = _DemoRepositoryFake();
    final loadDemo = LoadDemoUseCase(repository);
    final createDemo = CreateDemoUseCase(repository);
    final refreshDemo = RefreshDemoUseCase(repository);

    return MaterialApp(
      home: BlocProvider(
        create: (_) => DemoBloc(
          loadDemo,
          createDemo,
          refreshDemo,
        ),
        child: const DemoPage(),
      ),
    );
  }
}

/// Implementación mínima para probar el flujo del feature demo sin backend.
class _DemoRepositoryFake implements DemoRepository {
  @override
  Future<Either<Failure, void>> createDemo({required String title}) async {
    // Simula éxito inmediato.
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> loadDemo() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> refreshDemo() async {
    return const Right(null);
  }
}
