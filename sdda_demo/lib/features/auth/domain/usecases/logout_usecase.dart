import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para logout.
///
/// Retorna [Either<Failure, void>].
@lazySingleton
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repository;

  /// Crea una instancia de [LogoutUseCase].
  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    // Delegación al repository
    return _repository.logout();
  }
}
