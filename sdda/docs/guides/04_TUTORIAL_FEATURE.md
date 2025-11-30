# Tutorial: Crear un Feature Completo

Guía paso a paso para crear un feature desde cero usando SDDA.

---

## Objetivo

Crear el feature **"products"** con:
- Entity: Product
- UseCases: GetProducts, GetProductById, CreateProduct
- Repository con datasources
- BLoC para gestión de estado
- Tests completos

---

## Fase 1: SPECIFY (Especificar)

### 1.1 Crear Archivo de Especificación

Crea `sdda/01_specs/products_spec.yaml`:

```yaml
# ═══════════════════════════════════════════════════════════════════════════════
# ESPECIFICACIÓN: Feature Products
# ═══════════════════════════════════════════════════════════════════════════════

feature:
  name: products
  description: "Gestión de catálogo de productos"
  version: "1.0.0"

# ═══════════════════════════════════════════════════════════════════════════════
# ENTIDADES
# ═══════════════════════════════════════════════════════════════════════════════

entities:
  - name: Product
    description: "Representa un producto en el catálogo"
    properties:
      - name: id
        type: String
        required: true
        description: "Identificador único"

      - name: name
        type: String
        required: true
        description: "Nombre del producto"

      - name: description
        type: String?
        required: false
        description: "Descripción detallada"

      - name: price
        type: double
        required: true
        description: "Precio en moneda local"

      - name: imageUrl
        type: String?
        required: false
        description: "URL de imagen"

      - name: category
        type: String
        required: true
        description: "Categoría del producto"

      - name: isAvailable
        type: bool
        required: true
        description: "Si está disponible para venta"

# ═══════════════════════════════════════════════════════════════════════════════
# CASOS DE USO
# ═══════════════════════════════════════════════════════════════════════════════

usecases:
  - name: GetProducts
    description: "Obtiene lista paginada de productos"
    return_type: List<Product>
    params:
      - name: page
        type: int
        required: false
        default: 1
      - name: limit
        type: int
        required: false
        default: 20
      - name: category
        type: String?
        required: false
    validations:
      - "page debe ser >= 1"
      - "limit debe ser entre 1 y 100"
    failures:
      - NetworkFailure
      - ServerFailure

  - name: GetProductById
    description: "Obtiene un producto por su ID"
    return_type: Product
    params:
      - name: id
        type: String
        required: true
    validations:
      - "id no puede estar vacío"
    failures:
      - NotFoundFailure
      - NetworkFailure
      - ServerFailure

  - name: CreateProduct
    description: "Crea un nuevo producto"
    return_type: Product
    params:
      - name: name
        type: String
        required: true
      - name: price
        type: double
        required: true
      - name: category
        type: String
        required: true
      - name: description
        type: String?
        required: false
    validations:
      - "name no puede estar vacío"
      - "price debe ser > 0"
    failures:
      - ValidationFailure
      - NetworkFailure
      - ServerFailure

# ═══════════════════════════════════════════════════════════════════════════════
# REPOSITORY
# ═══════════════════════════════════════════════════════════════════════════════

repository:
  name: ProductsRepository
  has_remote_datasource: true
  has_local_datasource: true
  methods:
    - name: getProducts
      return_type: List<Product>
      params:
        - name: page
          type: int
        - name: limit
          type: int
        - name: category
          type: String?

    - name: getProductById
      return_type: Product
      params:
        - name: id
          type: String

    - name: createProduct
      return_type: Product
      params:
        - name: name
          type: String
        - name: price
          type: double
        - name: category
          type: String
        - name: description
          type: String?

# ═══════════════════════════════════════════════════════════════════════════════
# BLOC
# ═══════════════════════════════════════════════════════════════════════════════

bloc:
  name: Products
  supports_pagination: true
  events:
    - name: LoadProducts
      params:
        - name: page
          type: int
        - name: category
          type: String?

    - name: RefreshProducts

    - name: LoadMoreProducts

    - name: LoadProductDetail
      params:
        - name: id
          type: String

  states:
    - name: Initial
    - name: Loading
    - name: Loaded
      properties:
        - name: products
          type: List<Product>
        - name: hasMore
          type: bool
    - name: LoadingMore
    - name: DetailLoaded
      properties:
        - name: product
          type: Product
    - name: Error
      properties:
        - name: message
          type: String

# ═══════════════════════════════════════════════════════════════════════════════
# API
# ═══════════════════════════════════════════════════════════════════════════════

api:
  base_url: "/api/v1/products"
  endpoints:
    - method: GET
      path: /
      params: [page, limit, category]

    - method: GET
      path: /{id}

    - method: POST
      path: /
      body: [name, price, category, description]
```

### 1.2 Revisar Especificación

Verifica que la especificación está completa:

```bash
# Validar estructura YAML
cat sdda/01_specs/products_spec.yaml | head -50
```

---

## Fase 2: CONTRACT (Escribir Tests)

### 2.1 Crear Test de UseCase

Crea `sdda/02_contracts/unit/products/get_products_usecase_test.dart`:

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// CONTRATO: GetProductsUseCase

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late GetProductsUseCase sut;
  late MockProductsRepository mockRepository;

  // Test Data
  final tProducts = [
    Product(id: '1', name: 'Product 1', price: 10.0, category: 'cat1', isAvailable: true),
    Product(id: '2', name: 'Product 2', price: 20.0, category: 'cat1', isAvailable: true),
  ];
  const tPage = 1;
  const tLimit = 20;

  setUp(() {
    mockRepository = MockProductsRepository();
    sut = GetProductsUseCase(mockRepository);
  });

  group('GetProductsUseCase', () {
    group('casos de éxito', () {
      test('debe retornar List<Product> cuando es exitoso', () async {
        // Arrange
        when(() => mockRepository.getProducts(
              page: any(named: 'page'),
              limit: any(named: 'limit'),
              category: any(named: 'category'),
            )).thenAnswer((_) async => Right(tProducts));

        // Act
        final result = await sut(const GetProductsParams(page: tPage, limit: tLimit));

        // Assert
        expect(result, Right(tProducts));
        verify(() => mockRepository.getProducts(
              page: tPage,
              limit: tLimit,
              category: null,
            )).called(1);
      });

      test('debe filtrar por categoría cuando se especifica', () async {
        // Arrange
        when(() => mockRepository.getProducts(
              page: any(named: 'page'),
              limit: any(named: 'limit'),
              category: any(named: 'category'),
            )).thenAnswer((_) async => Right(tProducts));

        // Act
        await sut(const GetProductsParams(page: 1, limit: 20, category: 'electronics'));

        // Assert
        verify(() => mockRepository.getProducts(
              page: 1,
              limit: 20,
              category: 'electronics',
            )).called(1);
      });
    });

    group('validaciones', () {
      test('debe retornar ValidationFailure cuando page < 1', () async {
        // Act
        final result = await sut(const GetProductsParams(page: 0, limit: 20));

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (_) => fail('Debería ser failure'),
        );
        verifyNever(() => mockRepository.getProducts(
              page: any(named: 'page'),
              limit: any(named: 'limit'),
              category: any(named: 'category'),
            ));
      });

      test('debe retornar ValidationFailure cuando limit > 100', () async {
        // Act
        final result = await sut(const GetProductsParams(page: 1, limit: 150));

        // Assert
        expect(result.isLeft(), true);
      });

      test('debe retornar ValidationFailure cuando limit < 1', () async {
        // Act
        final result = await sut(const GetProductsParams(page: 1, limit: 0));

        // Assert
        expect(result.isLeft(), true);
      });
    });

    group('casos de error', () {
      test('debe propagar NetworkFailure', () async {
        // Arrange
        when(() => mockRepository.getProducts(
              page: any(named: 'page'),
              limit: any(named: 'limit'),
              category: any(named: 'category'),
            )).thenAnswer((_) async => const Left(NetworkFailure()));

        // Act
        final result = await sut(const GetProductsParams(page: 1, limit: 20));

        // Assert
        expect(result, const Left(NetworkFailure()));
      });

      test('debe propagar ServerFailure', () async {
        // Arrange
        when(() => mockRepository.getProducts(
              page: any(named: 'page'),
              limit: any(named: 'limit'),
              category: any(named: 'category'),
            )).thenAnswer((_) async => const Left(ServerFailure('Error')));

        // Act
        final result = await sut(const GetProductsParams(page: 1, limit: 20));

        // Assert
        expect(result.isLeft(), true);
      });
    });
  });
}

// Placeholders (en proyecto real vienen de imports)
abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    required int page,
    required int limit,
    String? category,
  });
}

class GetProductsUseCase {
  final ProductsRepository _repository;
  GetProductsUseCase(this._repository);

  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    if (params.page < 1) {
      return const Left(ValidationFailure('Page debe ser >= 1'));
    }
    if (params.limit < 1 || params.limit > 100) {
      return const Left(ValidationFailure('Limit debe ser entre 1 y 100'));
    }
    return _repository.getProducts(
      page: params.page,
      limit: params.limit,
      category: params.category,
    );
  }
}

class GetProductsParams {
  final int page;
  final int limit;
  final String? category;
  const GetProductsParams({this.page = 1, this.limit = 20, this.category});
}

class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final bool isAvailable;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.isAvailable,
  });
}

abstract class Failure {}
class ValidationFailure extends Failure {
  final String message;
  ValidationFailure(this.message);
}
class NetworkFailure extends Failure {
  const NetworkFailure();
}
class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message);
}
```

### 2.2 Crear Test de BLoC

Crea `sdda/02_contracts/unit/products/products_bloc_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// CONTRATO: ProductsBloc

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

void main() {
  late ProductsBloc sut;
  late MockGetProductsUseCase mockGetProductsUseCase;

  final tProducts = [
    Product(id: '1', name: 'Product 1', price: 10.0, category: 'cat1', isAvailable: true),
  ];

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    sut = ProductsBloc(getProductsUseCase: mockGetProductsUseCase);
  });

  setUpAll(() {
    registerFallbackValue(const GetProductsParams());
  });

  test('estado inicial es ProductsInitial', () {
    expect(sut.state, const ProductsInitial());
  });

  group('LoadProducts', () {
    blocTest<ProductsBloc, ProductsState>(
      'emite [Loading, Loaded] cuando es exitoso',
      build: () {
        when(() => mockGetProductsUseCase(any()))
            .thenAnswer((_) async => Right(tProducts));
        return sut;
      },
      act: (bloc) => bloc.add(const LoadProducts()),
      expect: () => [
        const ProductsLoading(),
        ProductsLoaded(products: tProducts, hasMore: true),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emite [Loading, Error] cuando falla',
      build: () {
        when(() => mockGetProductsUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Error')));
        return sut;
      },
      act: (bloc) => bloc.add(const LoadProducts()),
      expect: () => [
        const ProductsLoading(),
        const ProductsError(message: 'Error'),
      ],
    );
  });
}

// Placeholders
class ProductsBloc {
  ProductsState state = const ProductsInitial();
  ProductsBloc({required GetProductsUseCase getProductsUseCase});
  void add(ProductsEvent event) {}
}

abstract class ProductsEvent {}
class LoadProducts extends ProductsEvent {
  const LoadProducts();
}

abstract class ProductsState {
  const ProductsState();
}
class ProductsInitial extends ProductsState {
  const ProductsInitial();
}
class ProductsLoading extends ProductsState {
  const ProductsLoading();
}
class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool hasMore;
  const ProductsLoaded({required this.products, required this.hasMore});
}
class ProductsError extends ProductsState {
  final String message;
  const ProductsError({required this.message});
}

class GetProductsUseCase {
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    throw UnimplementedError();
  }
}
class GetProductsParams {
  const GetProductsParams();
}
class Product {
  final String id, name, category;
  final double price;
  final bool isAvailable;
  Product({required this.id, required this.name, required this.price, required this.category, required this.isAvailable});
}
abstract class Failure {}
class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message);
}
```

---

## Fase 3: GENERATE (Generar)

### 3.1 Generar Feature Completo

```bash
# Generar todo el feature
dart run sdda/05_generators/bin/sdda.dart generate feature products \
  --spec=sdda/01_specs/products_spec.yaml \
  --with-tests
```

### 3.2 Archivos Generados

```
lib/features/products/
├── data/
│   ├── datasources/
│   │   ├── products_remote_datasource.dart
│   │   └── products_local_datasource.dart
│   ├── models/
│   │   └── product_model.dart
│   └── repositories/
│       └── products_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── product.dart
│   ├── repositories/
│   │   └── products_repository.dart
│   └── usecases/
│       ├── get_products_usecase.dart
│       ├── get_product_by_id_usecase.dart
│       └── create_product_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── products_bloc.dart
    │   ├── products_event.dart
    │   └── products_state.dart
    └── pages/
        └── products_page.dart

test/features/products/
├── domain/usecases/
│   ├── get_products_usecase_test.dart
│   ├── get_product_by_id_usecase_test.dart
│   └── create_product_usecase_test.dart
└── presentation/bloc/
    └── products_bloc_test.dart
```

---

## Fase 4: VALIDATE (Validar)

### 4.1 Validar Convenciones

```bash
dart run sdda/05_generators/bin/sdda.dart validate --feature=products
```

Salida esperada:
```
SDDA Code Validator
══════════════════════════════════════════════════

Validando feature: products...

lib/features/products/domain/usecases/get_products_usecase.dart
  ✓ Tiene @lazySingleton
  ✓ Implementa UseCase
  ✓ Retorna Either<Failure, T>
  ✓ No importa de data layer

lib/features/products/presentation/bloc/products_bloc.dart
  ✓ Tiene @injectable
  ✓ Extiende Bloc
  ✓ Usa on<Event>

══════════════════════════════════════════════════
Resumen de Validación:
  Archivos analizados: 12
  Pasaron: 12
  Errores: 0
  Warnings: 0
```

### 4.2 Ejecutar Tests

```bash
# Tests unitarios
flutter test test/features/products/

# Con cobertura
flutter test test/features/products/ --coverage
```

Salida esperada:
```
00:05 +15: All tests passed!
```

### 4.3 Verificar Cobertura

```bash
# Generar reporte HTML
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Fase 5: Integrar en el Proyecto

### 5.1 Registrar en DI

```dart
// lib/core/di/injection.dart
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

### 5.2 Agregar Ruta

```dart
// lib/core/router/app_router.dart
GoRoute(
  path: '/products',
  builder: (context, state) => BlocProvider(
    create: (context) => getIt<ProductsBloc>()
      ..add(const LoadProducts()),
    child: const ProductsPage(),
  ),
),
```

### 5.3 Usar el Feature

```dart
// En cualquier widget
BlocBuilder<ProductsBloc, ProductsState>(
  builder: (context, state) {
    return switch (state) {
      ProductsInitial() => const SizedBox(),
      ProductsLoading() => const CircularProgressIndicator(),
      ProductsLoaded(:final products) => ProductsList(products: products),
      ProductsError(:final message) => ErrorWidget(message: message),
    };
  },
)
```

---

## Resumen del Flujo

| Fase | Acción | Resultado |
|------|--------|-----------|
| **SPECIFY** | Escribir `products_spec.yaml` | Especificación completa |
| **CONTRACT** | Escribir tests | Contratos que código debe cumplir |
| **GENERATE** | `sdda generate feature products` | Código generado |
| **VALIDATE** | `sdda validate` + `flutter test` | Código verificado |

---

## Siguiente Paso

Ver la [Guía de Flujo de Trabajo](./05_FLUJO_TRABAJO.md) para patrones avanzados.
