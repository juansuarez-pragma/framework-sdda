// ═══════════════════════════════════════════════════════════════════════════════
// EJEMPLO DE BLOC - REFERENCIA PARA GENERACIÓN DE CÓDIGO
// ═══════════════════════════════════════════════════════════════════════════════
//
// Este archivo sirve como REFERENCIA para que la IA genere BLoCs.
// SEGUIR EXACTAMENTE este patrón.
//
// Un BLoC consta de 3 archivos:
// 1. [feature]_bloc.dart   - Lógica del BLoC
// 2. [feature]_event.dart  - Eventos (inputs)
// 3. [feature]_state.dart  - Estados (outputs)
//
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Imports de ejemplo (ajustar según proyecto real)
// import '../../../domain/usecases/get_products_usecase.dart';
// import '../../../domain/entities/product.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// PARTE 1: EVENTS ([feature]_event.dart)
// ═══════════════════════════════════════════════════════════════════════════════

/// Eventos del ProductBloc.
///
/// Usa `sealed class` (Dart 3+) para exhaustividad en pattern matching.
sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Solicita cargar la lista de productos.
class LoadProducts extends ProductEvent {
  /// Página a cargar (default: 1).
  final int page;

  /// Cantidad por página (default: 20).
  final int limit;

  /// Categoría opcional para filtrar.
  final String? category;

  const LoadProducts({
    this.page = 1,
    this.limit = 20,
    this.category,
  });

  @override
  List<Object?> get props => [page, limit, category];
}

/// Solicita refrescar los productos (pull-to-refresh).
class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}

/// Solicita cargar más productos (paginación infinita).
class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}

/// Solicita buscar productos.
class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

/// Solicita filtrar por categoría.
class FilterByCategory extends ProductEvent {
  final String? category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

// ═══════════════════════════════════════════════════════════════════════════════
// PARTE 2: STATES ([feature]_state.dart)
// ═══════════════════════════════════════════════════════════════════════════════

/// Estados del ProductBloc.
///
/// Usa `sealed class` para exhaustividad en BlocBuilder/BlocListener.
sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial, antes de cualquier carga.
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// Cargando productos (primera carga).
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// Productos cargados exitosamente.
class ProductLoaded extends ProductState {
  /// Lista de productos.
  final List<Product> products;

  /// Página actual.
  final int currentPage;

  /// Si hay más páginas disponibles.
  final bool hasMore;

  /// Categoría activa (null = todas).
  final String? activeCategory;

  const ProductLoaded({
    required this.products,
    this.currentPage = 1,
    this.hasMore = true,
    this.activeCategory,
  });

  /// Crea una copia con nuevos valores.
  ProductLoaded copyWith({
    List<Product>? products,
    int? currentPage,
    bool? hasMore,
    String? activeCategory,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      activeCategory: activeCategory ?? this.activeCategory,
    );
  }

  @override
  List<Object?> get props => [products, currentPage, hasMore, activeCategory];
}

/// Cargando más productos (paginación).
class ProductLoadingMore extends ProductState {
  final List<Product> currentProducts;
  final int currentPage;

  const ProductLoadingMore({
    required this.currentProducts,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [currentProducts, currentPage];
}

/// Error al cargar productos.
class ProductError extends ProductState {
  /// Mensaje de error para mostrar al usuario.
  final String message;

  /// Productos previos (para mostrar mientras hay error).
  final List<Product>? previousProducts;

  const ProductError({
    required this.message,
    this.previousProducts,
  });

  @override
  List<Object?> get props => [message, previousProducts];
}

/// Lista vacía (sin productos).
class ProductEmpty extends ProductState {
  /// Mensaje explicativo.
  final String message;

  const ProductEmpty({
    this.message = 'No hay productos disponibles',
  });

  @override
  List<Object?> get props => [message];
}

// ═══════════════════════════════════════════════════════════════════════════════
// PARTE 3: BLOC ([feature]_bloc.dart)
// ═══════════════════════════════════════════════════════════════════════════════

/// BLoC para gestión de productos.
///
/// Maneja:
/// - Carga inicial de productos
/// - Paginación infinita
/// - Pull-to-refresh
/// - Búsqueda
/// - Filtrado por categoría
@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase _getProductsUseCase;

  /// Página actual para paginación.
  int _currentPage = 1;

  /// Categoría activa para filtrado.
  String? _activeCategory;

  ProductBloc(this._getProductsUseCase) : super(const ProductInitial()) {
    // Registrar handlers para cada evento
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<FilterByCategory>(_onFilterByCategory);
  }

  /// Maneja carga inicial de productos.
  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    // Emitir loading
    emit(const ProductLoading());

    // Resetear página
    _currentPage = event.page;
    _activeCategory = event.category;

    // Llamar al usecase
    final result = await _getProductsUseCase(
      GetProductsParams(
        page: event.page,
        limit: event.limit,
        category: event.category,
      ),
    );

    // Procesar resultado
    result.fold(
      // Error
      (failure) => emit(ProductError(message: failure.message)),
      // Éxito
      (products) {
        if (products.isEmpty) {
          emit(const ProductEmpty());
        } else {
          emit(ProductLoaded(
            products: products,
            currentPage: event.page,
            hasMore: products.length >= event.limit,
            activeCategory: event.category,
          ));
        }
      },
    );
  }

  /// Maneja pull-to-refresh.
  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    // No emitir loading para mantener lista visible durante refresh
    _currentPage = 1;

    final result = await _getProductsUseCase(
      GetProductsParams(
        page: 1,
        category: _activeCategory,
      ),
    );

    result.fold(
      (failure) {
        // En refresh, mostrar error pero mantener datos previos
        final currentState = state;
        if (currentState is ProductLoaded) {
          emit(ProductError(
            message: failure.message,
            previousProducts: currentState.products,
          ));
        } else {
          emit(ProductError(message: failure.message));
        }
      },
      (products) {
        if (products.isEmpty) {
          emit(const ProductEmpty());
        } else {
          emit(ProductLoaded(
            products: products,
            currentPage: 1,
            hasMore: products.length >= 20,
            activeCategory: _activeCategory,
          ));
        }
      },
    );
  }

  /// Maneja paginación infinita.
  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;

    // Solo cargar más si estamos en estado Loaded y hay más páginas
    if (currentState is! ProductLoaded || !currentState.hasMore) {
      return;
    }

    // Emitir estado de cargando más
    emit(ProductLoadingMore(
      currentProducts: currentState.products,
      currentPage: currentState.currentPage,
    ));

    final nextPage = _currentPage + 1;

    final result = await _getProductsUseCase(
      GetProductsParams(
        page: nextPage,
        category: _activeCategory,
      ),
    );

    result.fold(
      // Error: volver al estado anterior
      (failure) => emit(currentState),
      // Éxito: agregar productos
      (newProducts) {
        _currentPage = nextPage;

        emit(ProductLoaded(
          products: [...currentState.products, ...newProducts],
          currentPage: nextPage,
          hasMore: newProducts.length >= 20,
          activeCategory: _activeCategory,
        ));
      },
    );
  }

  /// Maneja filtrado por categoría.
  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<ProductState> emit,
  ) async {
    // Cargar productos con nueva categoría
    add(LoadProducts(category: event.category));
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TIPOS DE SOPORTE (normalmente en otros archivos)
// ═══════════════════════════════════════════════════════════════════════════════

// Placeholder - en proyecto real, importar de domain/entities
class Product {
  final String id;
  final String name;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

// Placeholder - en proyecto real, importar de domain/usecases
class GetProductsUseCase {
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    // Placeholder
    throw UnimplementedError();
  }
}

class GetProductsParams {
  final int page;
  final int limit;
  final String? category;

  const GetProductsParams({
    this.page = 1,
    this.limit = 20,
    this.category,
  });
}

// Placeholder - en proyecto real, importar de core/error
abstract class Failure {
  String get message;
}

class Either<L, R> {
  void fold(Function(L) onLeft, Function(R) onRight) {}
}
