import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para check auth status.
///
/// Retorna [Either<Failure, bool>].
@lazySingleton
class CheckAuthStatusUseCase implements UseCase<bool, NoParams> {
  final AuthRepository _repository;

  /// Crea una instancia de [CheckAuthStatusUseCase].
  CheckAuthStatusUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    // Delegación al repository
    return _repository.checkAuthStatus();
  }
}
