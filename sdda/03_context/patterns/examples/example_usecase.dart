// ═══════════════════════════════════════════════════════════════════════════════
// EJEMPLO DE USECASE - REFERENCIA PARA GENERACIÓN DE CÓDIGO
// ═══════════════════════════════════════════════════════════════════════════════
//
// Este archivo sirve como REFERENCIA para que la IA genere UseCases.
// SEGUIR EXACTAMENTE este patrón.
//
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Imports del proyecto (ajustar según ubicación real)
// import '../../../../core/error/failures.dart';
// import '../../../../core/usecases/usecase.dart';
// import '../entities/product.dart';
// import '../repositories/product_repository.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// INTERFAZ BASE DE USECASE
// ═══════════════════════════════════════════════════════════════════════════════

/// Interfaz base para todos los casos de uso.
///
/// [Type] es el tipo de retorno en caso de éxito.
/// [Params] es el tipo de parámetros de entrada.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Clase para casos de uso sin parámetros.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

// ═══════════════════════════════════════════════════════════════════════════════
// FAILURES BASE
// ═══════════════════════════════════════════════════════════════════════════════

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Error del servidor']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Sin conexión']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

// ═══════════════════════════════════════════════════════════════════════════════
// ENTIDAD DE EJEMPLO
// ═══════════════════════════════════════════════════════════════════════════════

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String? description;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [id, name, price, description, isAvailable];
}

// ═══════════════════════════════════════════════════════════════════════════════
// REPOSITORY INTERFACE
// ═══════════════════════════════════════════════════════════════════════════════

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
  });

  Future<Either<Failure, Product>> getProductById(String id);
}

// ═══════════════════════════════════════════════════════════════════════════════
// USECASE EJEMPLO: GetProducts
// ═══════════════════════════════════════════════════════════════════════════════

/// Caso de uso para obtener lista de productos.
///
/// Obtiene productos paginados del repositorio.
/// Valida los parámetros de entrada antes de llamar al repositorio.
///
/// ## Ejemplo de uso:
/// ```dart
/// final result = await getProductsUseCase(
///   GetProductsParams(page: 1, limit: 20),
/// );
///
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (products) => print('Productos: ${products.length}'),
/// );
/// ```
@lazySingleton
class GetProductsUseCase implements UseCase<List<Product>, GetProductsParams> {
  final ProductRepository _repository;

  /// Crea una instancia de [GetProductsUseCase].
  ///
  /// Requiere un [ProductRepository] para obtener los productos.
  GetProductsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    // ═══════════════════════════════════════════════════════════════════════
    // PASO 1: Validación de entrada
    // ═══════════════════════════════════════════════════════════════════════
    if (params.page < 1) {
      return const Left(ValidationFailure('La página debe ser mayor a 0'));
    }

    if (params.limit < 1 || params.limit > 100) {
      return const Left(
        ValidationFailure('El límite debe estar entre 1 y 100'),
      );
    }

    // ═══════════════════════════════════════════════════════════════════════
    // PASO 2: Delegación al repositorio
    // ═══════════════════════════════════════════════════════════════════════
    return _repository.getProducts(
      page: params.page,
      limit: params.limit,
      category: params.category,
    );
  }
}

/// Parámetros para [GetProductsUseCase].
class GetProductsParams extends Equatable {
  /// Número de página (comienza en 1).
  final int page;

  /// Cantidad de productos por página (máximo 100).
  final int limit;

  /// Categoría opcional para filtrar.
  final String? category;

  const GetProductsParams({
    this.page = 1,
    this.limit = 20,
    this.category,
  });

  @override
  List<Object?> get props => [page, limit, category];
}

// ═══════════════════════════════════════════════════════════════════════════════
// USECASE EJEMPLO: GetProductById
// ═══════════════════════════════════════════════════════════════════════════════

/// Caso de uso para obtener un producto por ID.
///
/// ## Validaciones:
/// - El ID no puede estar vacío
///
/// ## Retorna:
/// - [Right<Product>] si el producto existe
/// - [Left<Failure>] si hay error o no existe
@lazySingleton
class GetProductByIdUseCase implements UseCase<Product, GetProductByIdParams> {
  final ProductRepository _repository;

  GetProductByIdUseCase(this._repository);

  @override
  Future<Either<Failure, Product>> call(GetProductByIdParams params) async {
    // Validación
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('El ID del producto es requerido'));
    }

    // Normalizar ID (trim)
    final normalizedId = params.id.trim();

    // Delegación
    return _repository.getProductById(normalizedId);
  }
}

/// Parámetros para [GetProductByIdUseCase].
class GetProductByIdParams extends Equatable {
  /// ID del producto a buscar.
  final String id;

  const GetProductByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

// ═══════════════════════════════════════════════════════════════════════════════
// USECASE EJEMPLO SIN PARÁMETROS
// ═══════════════════════════════════════════════════════════════════════════════

/// Caso de uso para obtener productos destacados.
///
/// No requiere parámetros, retorna los productos destacados del sistema.
@lazySingleton
class GetFeaturedProductsUseCase
    implements UseCase<List<Product>, NoParams> {
  final ProductRepository _repository;

  GetFeaturedProductsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    // Sin validación necesaria (NoParams)
    // Directamente al repositorio
    return _repository.getProducts(
      page: 1,
      limit: 10,
      category: 'featured',
    );
  }
}
