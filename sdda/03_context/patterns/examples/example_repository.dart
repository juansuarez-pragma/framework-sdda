// ═══════════════════════════════════════════════════════════════════════════════
// EJEMPLO DE REPOSITORY - REFERENCIA PARA GENERACIÓN DE CÓDIGO
// ═══════════════════════════════════════════════════════════════════════════════
//
// Este archivo sirve como REFERENCIA para que la IA genere Repositories.
// SEGUIR EXACTAMENTE este patrón.
//
// Un Repository consta de 2 partes:
// 1. Interface (en domain/repositories/)
// 2. Implementación (en data/repositories/)
//
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Imports de ejemplo
// import '../../../../core/error/exceptions.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/network/network_info.dart';
// import '../../domain/entities/user.dart';
// import '../../domain/repositories/auth_repository.dart';
// import '../datasources/auth_local_datasource.dart';
// import '../datasources/auth_remote_datasource.dart';
// import '../models/user_model.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// PARTE 1: INTERFACE (domain/repositories/auth_repository.dart)
// ═══════════════════════════════════════════════════════════════════════════════

/// Contrato del repositorio de autenticación.
///
/// Define las operaciones disponibles sin detalles de implementación.
/// La capa de dominio solo conoce esta interfaz.
abstract class AuthRepository {
  /// Autentica un usuario con email y contraseña.
  ///
  /// Retorna [Right<User>] si las credenciales son válidas.
  /// Retorna [Left<Failure>] si hay error:
  /// - [InvalidCredentialsFailure] si las credenciales son incorrectas
  /// - [NetworkFailure] si no hay conexión
  /// - [ServerFailure] si hay error del servidor
  Future<Either<Failure, User>> login(String email, String password);

  /// Cierra la sesión del usuario actual.
  Future<Either<Failure, void>> logout();

  /// Obtiene el usuario actualmente autenticado.
  ///
  /// Retorna [null] si no hay sesión activa.
  Future<Either<Failure, User?>> getCurrentUser();

  /// Registra un nuevo usuario.
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });

  /// Verifica si hay una sesión activa.
  Future<bool> isAuthenticated();
}

// ═══════════════════════════════════════════════════════════════════════════════
// PARTE 2: IMPLEMENTACIÓN (data/repositories/auth_repository_impl.dart)
// ═══════════════════════════════════════════════════════════════════════════════

/// Implementación del repositorio de autenticación.
///
/// Coordina entre:
/// - [AuthRemoteDataSource] para operaciones con el servidor
/// - [AuthLocalDataSource] para caché y persistencia
/// - [NetworkInfo] para verificar conectividad
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    // ═══════════════════════════════════════════════════════════════════════
    // Paso 1: Verificar conectividad
    // ═══════════════════════════════════════════════════════════════════════
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    // ═══════════════════════════════════════════════════════════════════════
    // Paso 2: Intentar login remoto
    // ═══════════════════════════════════════════════════════════════════════
    try {
      final userModel = await _remoteDataSource.login(email, password);

      // ═══════════════════════════════════════════════════════════════════
      // Paso 3: Guardar en caché local
      // ═══════════════════════════════════════════════════════════════════
      await _localDataSource.cacheUser(userModel);
      await _localDataSource.cacheToken(userModel.token);

      // ═══════════════════════════════════════════════════════════════════
      // Paso 4: Retornar entidad de dominio
      // ═══════════════════════════════════════════════════════════════════
      return Right(userModel.toEntity());

    } on InvalidCredentialsException {
      return const Left(InvalidCredentialsFailure());

    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));

    } on Exception catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Intentar logout en servidor si hay conexión
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.logout();
      }

      // Siempre limpiar datos locales
      await _localDataSource.clearUser();
      await _localDataSource.clearToken();

      return const Right(null);

    } on Exception catch (e) {
      // Aún si falla el servidor, limpiar local
      await _localDataSource.clearUser();
      await _localDataSource.clearToken();

      return Left(ServerFailure('Error en logout: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // Primero intentar obtener del caché
      final cachedUser = await _localDataSource.getCachedUser();

      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }

      // Si no hay caché y hay conexión, intentar del servidor
      if (await _networkInfo.isConnected) {
        final token = await _localDataSource.getToken();

        if (token != null) {
          try {
            final userModel = await _remoteDataSource.getCurrentUser(token);
            await _localDataSource.cacheUser(userModel);
            return Right(userModel.toEntity());
          } on UnauthorizedException {
            // Token inválido, limpiar
            await _localDataSource.clearToken();
            return const Right(null);
          }
        }
      }

      return const Right(null);

    } on CacheException {
      return const Right(null);

    } on Exception catch (e) {
      return Left(ServerFailure('Error obteniendo usuario: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    try {
      final userModel = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );

      await _localDataSource.cacheUser(userModel);
      await _localDataSource.cacheToken(userModel.token);

      return Right(userModel.toEntity());

    } on EmailAlreadyExistsException {
      return const Left(ValidationFailure('El email ya está registrado'));

    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));

    } on Exception catch (e) {
      return Left(ServerFailure('Error en registro: $e'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DATASOURCES (para referencia)
// ═══════════════════════════════════════════════════════════════════════════════

/// DataSource remoto para autenticación.
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser(String token);
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });
}

/// DataSource local para autenticación.
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

/// Información de conectividad.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// ═══════════════════════════════════════════════════════════════════════════════
// TIPOS DE SOPORTE (placeholders)
// ═══════════════════════════════════════════════════════════════════════════════

class User {
  final String id;
  final String email;
  final String name;

  const User({required this.id, required this.email, required this.name});
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final String token;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
  });

  User toEntity() => User(id: id, email: email, name: name);
}

// Failures
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Sin conexión']) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Error del servidor']) : super(message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('Credenciales inválidas');
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

// Exceptions
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class InvalidCredentialsException implements Exception {}
class UnauthorizedException implements Exception {}
class EmailAlreadyExistsException implements Exception {}
class CacheException implements Exception {}

// Either placeholder
class Either<L, R> {
  static Either<L, R> left<L, R>(L value) => Left(value);
  static Either<L, R> right<L, R>(R value) => Right(value);
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);
}
