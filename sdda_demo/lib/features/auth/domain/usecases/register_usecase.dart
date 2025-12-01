import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';

/// Caso de uso para register.
///
/// Retorna [Either<Failure, User>].
@lazySingleton
class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository _repository;

  /// Crea una instancia de [RegisterUseCase].
  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    // Validaciones
    // Debe ser un email válido
    // Debe tener mínimo 6 caracteres
    // No puede estar vacío

    // Delegación al repository
    return _repository.register(email: params.email, password: params.password, name: params.name);
  }
}

/// Parámetros para [RegisterUseCase].
class RegisterParams extends Equatable {
  /// email
  final String email;

  /// password
  final String password;

  /// name
  final String name;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}
