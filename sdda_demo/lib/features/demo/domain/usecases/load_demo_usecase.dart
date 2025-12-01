import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/demo_repository.dart';

/// Caso de uso para load demo.
///
/// Retorna [Either<Failure, void>].
@lazySingleton
class LoadDemoUseCase implements UseCase<void, NoParams> {
  final DemoRepository _repository;

  /// Crea una instancia de [LoadDemoUseCase].
  LoadDemoUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    // Delegación al repository
    return _repository.loadDemo();
  }
}
