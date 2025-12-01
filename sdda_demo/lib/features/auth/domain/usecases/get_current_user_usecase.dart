import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';

/// Caso de uso para get current user.
///
/// Retorna [Either<Failure, User?>].
@lazySingleton
class GetCurrentUserUseCase implements UseCase<User?, NoParams> {
  final AuthRepository _repository;

  /// Crea una instancia de [GetCurrentUserUseCase].
  GetCurrentUserUseCase(this._repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    // Delegación al repository
    return _repository.getCurrentUser();
  }
}
