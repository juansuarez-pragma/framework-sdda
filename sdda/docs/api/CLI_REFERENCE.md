# Referencia del CLI SDDA

Documentación completa de todos los comandos del CLI.

---

## Visión General

```bash
sdda <comando> [opciones]
```

### Comandos Disponibles

| Comando | Descripción |
|---------|-------------|
| `init` | Inicializa SDDA en un proyecto |
| `generate` | Genera código desde especificaciones |
| `validate` | Valida código contra convenciones |
| `prompt` | Genera prompts para IA |
| `help` | Muestra ayuda |

---

## sdda init

Inicializa la estructura SDDA en un proyecto Flutter.

### Sintaxis

```bash
sdda init [opciones]
```

### Opciones

| Opción | Alias | Descripción | Default |
|--------|-------|-------------|---------|
| `--path` | `-p` | Directorio del proyecto | `.` (actual) |
| `--force` | `-f` | Sobrescribir si existe | `false` |
| `--with-examples` | `-e` | Incluir ejemplos | `true` |
| `--minimal` | `-m` | Solo estructura básica | `false` |

### Ejemplos

```bash
# Inicialización estándar
sdda init

# En directorio específico
sdda init --path=/path/to/project

# Forzar reinicialización
sdda init --force

# Sin ejemplos
sdda init --with-examples=false

# Solo estructura mínima
sdda init --minimal
```

### Estructura Creada

```
sdda/
├── sdda.yaml              # Configuración principal
├── 01_specs/              # Especificaciones
│   ├── templates/         # Plantillas YAML
│   └── features/          # Features del proyecto
├── 02_contracts/          # Tests-contrato
│   ├── unit/
│   ├── widget/
│   ├── integration/
│   └── e2e/
├── 03_context/            # Contexto para IA
│   ├── architecture/
│   ├── patterns/
│   ├── conventions/
│   └── glossary/
├── 04_prompts/            # Sistema de prompts
│   ├── system/
│   ├── generation/
│   ├── testing/
│   └── validation/
├── 05_generators/         # Generadores
└── 06_examples/           # Ejemplos completos
```

---

## sdda generate

Genera código desde especificaciones.

### Sintaxis

```bash
sdda generate <tipo> <nombre> [opciones]
```

### Tipos de Generación

| Tipo | Descripción |
|------|-------------|
| `feature` | Feature completo con todas las capas |
| `usecase` | UseCase individual |
| `bloc` | BLoC con eventos y estados |
| `repository` | Repository interface e implementación |
| `entity` | Entity del dominio |
| `model` | Model de data (con JSON) |
| `datasource` | DataSource (remote/local) |
| `test` | Tests para un componente |
| `tests` | Todos los tests de un feature |

### Opciones Globales

| Opción | Alias | Descripción | Default |
|--------|-------|-------------|---------|
| `--spec` | `-s` | Ruta al archivo de especificación | Auto-detect |
| `--feature` | `-f` | Nombre del feature padre | Requerido para componentes |
| `--output` | `-o` | Directorio de salida | `lib/features/<nombre>` |
| `--force` | | Sobrescribir existentes | `false` |
| `--dry-run` | | Solo mostrar qué se generaría | `false` |
| `--verbose` | `-v` | Salida detallada | `false` |

---

### sdda generate feature

Genera un feature completo.

```bash
sdda generate feature <nombre> --spec=<path> [opciones]
```

#### Opciones Específicas

| Opción | Descripción | Default |
|--------|-------------|---------|
| `--with-tests` | Generar tests | `true` |
| `--with-ui` | Generar páginas/widgets | `true` |
| `--skeleton-only` | Solo estructura, sin implementación | `false` |
| `--layers` | Capas a generar | `domain,data,presentation` |

#### Ejemplos

```bash
# Feature completo
sdda generate feature products --spec=sdda/01_specs/features/products/spec.yaml

# Sin UI
sdda generate feature products --spec=spec.yaml --with-ui=false

# Solo estructura
sdda generate feature products --spec=spec.yaml --skeleton-only

# Solo domain y data
sdda generate feature products --spec=spec.yaml --layers=domain,data

# Preview sin generar
sdda generate feature products --spec=spec.yaml --dry-run
```

#### Archivos Generados

```
lib/features/products/
├── domain/
│   ├── entities/
│   │   └── product.dart
│   ├── repositories/
│   │   └── product_repository.dart
│   └── usecases/
│       ├── get_products.dart
│       └── get_product_by_id.dart
├── data/
│   ├── models/
│   │   └── product_model.dart
│   ├── repositories/
│   │   └── product_repository_impl.dart
│   └── datasources/
│       ├── product_remote_datasource.dart
│       └── product_local_datasource.dart
└── presentation/
    ├── bloc/
    │   ├── product_bloc.dart
    │   ├── product_event.dart
    │   └── product_state.dart
    └── pages/
        └── products_page.dart
```

---

### sdda generate usecase

Genera un UseCase individual.

```bash
sdda generate usecase <nombre> --feature=<feature> [opciones]
```

#### Opciones Específicas

| Opción | Descripción | Default |
|--------|-------------|---------|
| `--params` | Tipo de parámetros | Auto desde spec |
| `--return` | Tipo de retorno | Auto desde spec |
| `--with-test` | Generar test | `true` |

#### Ejemplos

```bash
# UseCase básico
sdda generate usecase get_products --feature=products

# Con tipos explícitos
sdda generate usecase get_products --feature=products \
  --params=GetProductsParams \
  --return="List<Product>"

# Sin test
sdda generate usecase get_products --feature=products --with-test=false
```

#### Archivo Generado

```dart
// lib/features/products/domain/usecases/get_products.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts implements UseCase<List<Product>, GetProductsParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    return await repository.getProducts(
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class GetProductsParams {
  final int page;
  final int pageSize;

  const GetProductsParams({
    this.page = 1,
    this.pageSize = 20,
  });
}
```

---

### sdda generate bloc

Genera un BLoC completo.

```bash
sdda generate bloc <nombre> --feature=<feature> [opciones]
```

#### Opciones Específicas

| Opción | Descripción | Default |
|--------|-------------|---------|
| `--events` | Lista de eventos | Auto desde spec |
| `--states` | Lista de estados | Auto desde spec |
| `--usecases` | UseCases a inyectar | Auto desde spec |
| `--sealed` | Usar sealed classes (Dart 3+) | `true` |

#### Ejemplos

```bash
# BLoC básico
sdda generate bloc products --feature=products

# Con eventos específicos
sdda generate bloc products --feature=products \
  --events=LoadProducts,RefreshProducts,SearchProducts

# Sin sealed classes
sdda generate bloc products --feature=products --sealed=false
```

#### Archivos Generados

```dart
// product_event.dart
sealed class ProductEvent {}

final class LoadProducts extends ProductEvent {
  final int page;
  LoadProducts({this.page = 1});
}

final class RefreshProducts extends ProductEvent {}

// product_state.dart
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded({required this.products});
}

final class ProductError extends ProductState {
  final String message;
  ProductError({required this.message});
}

// product_bloc.dart
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;

  ProductBloc({required this.getProducts}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await getProducts(GetProductsParams(page: event.page));
    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (products) => emit(ProductLoaded(products: products)),
    );
  }
}
```

---

### sdda generate repository

Genera Repository interface e implementación.

```bash
sdda generate repository <nombre> --feature=<feature> [opciones]
```

#### Opciones Específicas

| Opción | Descripción | Default |
|--------|-------------|---------|
| `--methods` | Métodos del repository | Auto desde spec |
| `--with-cache` | Incluir lógica de cache | `true` |
| `--impl-only` | Solo implementación | `false` |
| `--interface-only` | Solo interface | `false` |

#### Ejemplos

```bash
# Repository completo
sdda generate repository products --feature=products

# Solo interface
sdda generate repository products --feature=products --interface-only

# Sin lógica de cache
sdda generate repository products --feature=products --with-cache=false
```

---

### sdda generate test

Genera tests para un componente.

```bash
sdda generate test <tipo> <nombre> --feature=<feature> [opciones]
```

#### Tipos de Test

| Tipo | Descripción |
|------|-------------|
| `usecase` | Test de UseCase |
| `bloc` | Test de BLoC |
| `repository` | Test de Repository |
| `widget` | Test de Widget |
| `integration` | Test de integración |

#### Ejemplos

```bash
# Test de UseCase
sdda generate test usecase get_products --feature=products

# Test de BLoC
sdda generate test bloc products --feature=products

# Test de Repository
sdda generate test repository products --feature=products
```

---

## sdda validate

Valida código contra convenciones SDDA.

### Sintaxis

```bash
sdda validate [target] [opciones]
```

### Targets

| Target | Descripción |
|--------|-------------|
| `--all` | Todo el proyecto |
| `--feature=<nombre>` | Feature específico |
| `<path>` | Archivo o directorio |

### Opciones

| Opción | Alias | Descripción | Default |
|--------|-------|-------------|---------|
| `--architecture` | `-a` | Validar arquitectura | `true` |
| `--naming` | `-n` | Validar nombrado | `true` |
| `--structure` | `-s` | Validar estructura | `true` |
| `--tests` | `-t` | Validar tests existen | `true` |
| `--coverage` | `-c` | Verificar cobertura | `false` |
| `--min-coverage` | | Cobertura mínima | `80` |
| `--fix` | | Auto-corregir si es posible | `false` |
| `--report` | `-r` | Generar reporte | `false` |
| `--format` | | Formato del reporte | `text` |

### Ejemplos

```bash
# Validar todo
sdda validate --all

# Validar feature específico
sdda validate --feature=products

# Validar archivo
sdda validate lib/features/products/domain/usecases/get_products.dart

# Solo arquitectura
sdda validate --all --architecture --naming=false --structure=false

# Con verificación de cobertura
sdda validate --all --coverage --min-coverage=85

# Generar reporte JSON
sdda validate --all --report --format=json > validation-report.json

# Auto-corregir problemas
sdda validate --all --fix
```

### Salida

```
═══════════════════════════════════════════════════════════════════════════════
                              SDDA VALIDATION REPORT
═══════════════════════════════════════════════════════════════════════════════

Feature: products
───────────────────────────────────────────────────────────────────────────────

✓ Architecture validation passed
  - No layer violations found
  - All dependencies flow correctly

✓ Naming conventions passed
  - 12 files checked
  - All follow conventions

✓ Structure validation passed
  - All required directories present
  - All required files present

✓ Tests validation passed
  - 8 test files found
  - All components have tests

───────────────────────────────────────────────────────────────────────────────
SUMMARY: 4 checks passed, 0 warnings, 0 errors
═══════════════════════════════════════════════════════════════════════════════
```

### Errores Comunes

| Error | Descripción | Solución |
|-------|-------------|----------|
| `ARCH001` | Import de capa prohibida | Corregir import |
| `NAME001` | Clase no sigue PascalCase | Renombrar clase |
| `NAME002` | Archivo no sigue snake_case | Renombrar archivo |
| `STRUCT001` | Directorio faltante | Crear directorio |
| `TEST001` | Test faltante | Crear test |
| `COV001` | Cobertura insuficiente | Agregar tests |

---

## sdda prompt

Genera prompts para usar con IA.

### Sintaxis

```bash
sdda prompt <tipo> [opciones]
```

### Tipos de Prompt

| Tipo | Descripción |
|------|-------------|
| `feature` | Prompt para feature completo |
| `usecase` | Prompt para UseCase |
| `bloc` | Prompt para BLoC |
| `repository` | Prompt para Repository |
| `test` | Prompt para tests |
| `fix` | Prompt para corregir código |
| `refactor` | Prompt para refactorizar |

### Opciones

| Opción | Alias | Descripción | Default |
|--------|-------|-------------|---------|
| `--spec` | `-s` | Especificación a incluir | Auto |
| `--feature` | `-f` | Feature relacionado | Requerido |
| `--name` | `-n` | Nombre del componente | Requerido para algunos |
| `--output` | `-o` | Archivo de salida | stdout |
| `--context` | `-c` | Nivel de contexto | `medium` |
| `--include-tests` | | Incluir tests existentes | `true` |
| `--include-examples` | | Incluir ejemplos | `true` |
| `--clipboard` | | Copiar al portapapeles | `false` |

### Niveles de Contexto

| Nivel | Contenido | Tokens Aprox |
|-------|-----------|--------------|
| `minimal` | Solo spec | ~500-1000 |
| `medium` | Spec + 1 ejemplo + convenciones | ~2000-4000 |
| `full` | Todo el contexto disponible | ~8000+ |

### Ejemplos

```bash
# Prompt para feature completo
sdda prompt feature --name=products --spec=spec.yaml

# Prompt para UseCase específico
sdda prompt usecase --feature=products --name=get_products

# Con contexto completo
sdda prompt feature --name=products --context=full

# Guardar a archivo
sdda prompt feature --name=products --output=prompt_products.md

# Copiar al portapapeles
sdda prompt usecase --feature=products --name=get_products --clipboard

# Sin ejemplos (más corto)
sdda prompt bloc --feature=products --include-examples=false
```

### Estructura del Prompt Generado

```markdown
# Prompt: Generate [Tipo] - [Nombre]

## Context

### Architecture
[Extracto de ARCHITECTURE.md]

### Conventions
[Extracto de CONVENTIONS.md]

## Specification

[Contenido del spec.yaml relevante]

## Examples

### Example: [Nombre del ejemplo]
```dart
[Código del ejemplo]
```

## Existing Code (if any)

[Código existente relacionado]

## Tests (Contract)

[Tests existentes que deben pasar]

## Task

Generate the [componente] following the specification above.
Ensure the code:
1. Follows all conventions
2. Matches the examples
3. Passes the tests
4. Uses only existing dependencies
```

---

## sdda help

Muestra ayuda del CLI.

### Sintaxis

```bash
sdda help [comando]
```

### Ejemplos

```bash
# Ayuda general
sdda help

# Ayuda de comando específico
sdda help generate

# Ayuda de subcomando
sdda help generate feature
```

---

## Configuración Global

### Archivo sdda.yaml

```yaml
# sdda.yaml - Configuración del proyecto

version: "1.0.0"

# Configuración de proyecto
project:
  name: my_app
  package: com.example.myapp

# Rutas
paths:
  specs: sdda/01_specs
  contracts: sdda/02_contracts
  context: sdda/03_context
  prompts: sdda/04_prompts
  generators: sdda/05_generators
  examples: sdda/06_examples
  features: lib/features
  tests: test/features

# Arquitectura
architecture:
  layers:
    - domain
    - data
    - presentation
  dependencies:
    domain: []
    data: [domain]
    presentation: [domain]

# Convenciones
conventions:
  naming:
    classes: PascalCase
    files: snake_case
    variables: camelCase
  suffixes:
    usecase: UseCase
    bloc: Bloc
    repository: Repository
    datasource: DataSource

# Validación
validation:
  coverage:
    minimum: 80
    target: 90
  architecture:
    strict: true
  naming:
    strict: true

# Generación
generation:
  tests: true
  documentation: true
  force: false

# Prompts
prompts:
  context_level: medium
  include_examples: true
  include_tests: true
```

---

## Variables de Entorno

| Variable | Descripción | Default |
|----------|-------------|---------|
| `SDDA_CONFIG` | Ruta a sdda.yaml | `./sdda/sdda.yaml` |
| `SDDA_VERBOSE` | Modo verbose | `false` |
| `SDDA_NO_COLOR` | Deshabilitar colores | `false` |

```bash
# Ejemplo
export SDDA_CONFIG=/custom/path/sdda.yaml
export SDDA_VERBOSE=true
sdda validate --all
```

---

## Códigos de Salida

| Código | Significado |
|--------|-------------|
| `0` | Éxito |
| `1` | Error general |
| `2` | Error de validación |
| `3` | Error de configuración |
| `4` | Archivo no encontrado |
| `5` | Error de sintaxis YAML |

---

## Siguiente Paso

Ver la [Referencia de Prompts](./PROMPTS_REFERENCE.md) para detalles del sistema de prompts.
