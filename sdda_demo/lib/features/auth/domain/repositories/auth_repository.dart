import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Contrato del repositorio de auth.
///
/// Define las operaciones disponibles sin detalles de implementación.
abstract class AuthRepository {

  /// Login con credenciales.
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Logout y limpieza de sesión.
  Future<Either<Failure, void>> logout();

  /// Usuario autenticado actualmente (puede ser null).
  Future<Either<Failure, User?>> getCurrentUser();

  /// Registro de usuario.
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });

  /// Estado de autenticación.
  Future<Either<Failure, bool>> checkAuthStatus();
}
