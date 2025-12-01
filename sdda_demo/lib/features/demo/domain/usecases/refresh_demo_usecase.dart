import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/demo_repository.dart';

/// Caso de uso para refresh demo.
///
/// Retorna [Either<Failure, void>].
@lazySingleton
class RefreshDemoUseCase implements UseCase<void, NoParams> {
  final DemoRepository _repository;

  /// Crea una instancia de [RefreshDemoUseCase].
  RefreshDemoUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    // Delegación al repository
    return _repository.refreshDemo();
  }
}
