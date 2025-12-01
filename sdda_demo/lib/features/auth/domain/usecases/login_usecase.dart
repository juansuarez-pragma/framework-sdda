import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';

/// Caso de uso para login.
///
/// Retorna [Either<Failure, User>].
@lazySingleton
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _repository;

  /// Crea una instancia de [LoginUseCase].
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Validaciones
    // Debe ser un email válido (contener @)
    // Debe tener mínimo 6 caracteres

    // Delegación al repository
    return _repository.login(email: params.email, password: params.password);
  }
}

/// Parámetros para [LoginUseCase].
class LoginParams extends Equatable {
  /// email
  final String email;

  /// password
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
